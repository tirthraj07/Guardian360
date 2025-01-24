from consumers.base_consumer import BaseConsumer

class GenericAlertConsumer(BaseConsumer):
    def __init__(self):
        super().__init__(group_id="Generic_Alert_Consumer_Group", partition=3)