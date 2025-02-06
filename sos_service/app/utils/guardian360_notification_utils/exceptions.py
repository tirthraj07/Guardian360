class NotificationNotInitializedError(Exception):
    """Exception raised when a notification is not initialized."""
    def __init__(self, message="Notification was not initialized before sending."):
        self.message = message
        super().__init__(self.message)

class NotificationIncorrectlyInitializedError(Exception):
    """Exception raised when a notification is incorrectly/incompletely initialized."""
    def __init__(self, message="Notification incorrectly/incompletely initialized before sending."):
        self.message = message
        super().__init__(self.message)

class IncorrectMetadataFormat(Exception):
    """Exception raised when a metadata in notification is incorrectly/incompletely initialized."""
    def __init__(self, message="Metadata in notification incorrectly/incompletely initialized before sending."):
        self.message = message
        super().__init__(self.message)
