"use strict";

const API_BASE_URL = "https://hack-or-snooze-v3.herokuapp.com";

class Article {
  constructor({ id, title, author, url, username, publishedAt }) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.url = url;
    this.username = username;
    this.publishedAt = publishedAt;
  }

  getDomain() {
    return new URL(this.url).host;
  }
}

class ArticleCollection {
  constructor(articles) {
    this.articles = articles;
  }

  static async fetchArticles() {
    const response = await axios({
      url: `${API_BASE_URL}/stories`,
      method: "GET",
    });

    const articles = response.data.stories.map(article => new Article(article));

    return new ArticleCollection(articles);
  }

  async addArticle(user, { title, author, url }) {
    const token = user.token;
    const response = await axios({
      method: "POST",
      url: `${API_BASE_URL}/stories`,
      data: { token, story: { title, author, url } },
    });

    const article = new Article(response.data.story);
    this.articles.unshift(article);
    user.articles.unshift(article);

    return article;
  }

  async deleteArticle(user, articleId) {
    const token = user.token;
    await axios({
      url: `${API_BASE_URL}/stories/${articleId}`,
      method: "DELETE",
      data: { token }
    });

    this.articles = this.articles.filter(article => article.id !== articleId);
    user.articles = user.articles.filter(a => a.id !== articleId);
  }
}

class User {
  constructor({ username, name, createdAt, favorites = [], articles = [] }, token) {
    this.username = username;
    this.name = name;
    this.createdAt = createdAt;
    this.favorites = favorites.map(f => new Article(f));
    this.articles = articles.map(a => new Article(a));
    this.token = token;
  }

  static async register(username, password, name) {
    const response = await axios({
      url: `${API_BASE_URL}/signup`,
      method: "POST",
      data: { user: { username, password, name } },
    });

    const userData = response.data.user;

    return new User(
      {
        username: userData.username,
        name: userData.name,
        createdAt: userData.createdAt,
        favorites: userData.favorites,
        articles: userData.stories
      },
      response.data.token
    );
  }

  static async signIn(username, password) {
    const response = await axios({
      url: `${API_BASE_URL}/login`,
      method: "POST",
      data: { user: { username, password } },
    });

    const userData = response.data.user;

    return new User(
      {
        username: userData.username,
        name: userData.name,
        createdAt: userData.createdAt,
        favorites: userData.favorites,
        articles: userData.stories
      },
      response.data.token
    );
  }

  static async autoSignIn(token, username) {
    try {
      const response = await axios({
        url: `${API_BASE_URL}/users/${username}`,
        method: "GET",
        params: { token },
      });

      const userData = response.data.user;

      return new User(
        {
          username: userData.username,
          name: userData.name,
          createdAt: userData.createdAt,
          favorites: userData.favorites,
          articles: userData.stories
        },
        token
      );
    } catch (err) {
      console.error("Auto sign-in failed", err);
      return null;
    }
  }

  async addFavorite(article) {
    this.favorites.push(article);
    await this._addOrRemoveFavorite("add", article)
  }

  async removeFavorite(article) {
    this.favorites = this.favorites.filter(f => f.id !== article.id);
    await this._addOrRemoveFavorite("remove", article);
  }

  async _addOrRemoveFavorite(action, article) {
    const method = action === "add" ? "POST" : "DELETE";
    const token = this.token;
    await axios({
      url: `${API_BASE_URL}/users/${this.username}/favorites/${article.id}`,
      method: method,
      data: { token },
    });
  }

  isFavorite(article) {
    return this.favorites.some(f => f.id === article.id);
  }
}
