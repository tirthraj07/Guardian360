from consumers.base_consumer import BaseConsumer

class AdaptiveLocationAlertConsumer(BaseConsumer):
    def __init__(self):
        super().__init__(group_id="Adaptive_Location_Alert_Consumer_Group", partition=1)