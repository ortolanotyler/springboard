# words.py

def print_upper_words(words, must_start_with=None):
    """
    Print words from a list in uppercase that start with specified letters.

    Args:
        words (list): List of words.
        must_start_with (set): Set of letters to filter words by. Default is None.

    Returns:
        None
    """
    for word in words:
        if must_start_with is None or any(word.startswith(letter) for letter in must_start_with):
            print(word.upper())

# Test the function
if __name__ == "__main__":
    word_list = ["hello", "hey", "goodbye", "yo", "yes"]
    print_upper_words(word_list, must_start_with={"h", "y"})




