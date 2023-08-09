class SerialGenerator:
    """Machine to create unique incrementing serial numbers.
    
    Example Usage:
    
    >>> serial = SerialGenerator(start=100)
    >>> serial.generate()
    100
    >>> serial.generate()
    101
    >>> serial.generate()
    102
    >>> serial.reset()
    >>> serial.generate()
    100
    """
    
    def __init__(self, start):
        """Initialize the serial number generator with a start value."""
        self.start = start
        self.next_serial = start
    
    def generate(self):
        """Generate the next sequential serial number."""
        serial_number = self.next_serial
        self.next_serial += 1
        return serial_number
    
    def reset(self):
        """Reset the serial number back to the original start value."""
        self.next_serial = self.start
