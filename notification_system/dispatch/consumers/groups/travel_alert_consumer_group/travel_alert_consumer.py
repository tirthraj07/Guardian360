from consumers.base_consumer import BaseConsumer

class TravelAlertConsumer(BaseConsumer):
    def __init__(self):
        super().__init__(group_id="Travel_Alert_Consumer_Group", partition=2)