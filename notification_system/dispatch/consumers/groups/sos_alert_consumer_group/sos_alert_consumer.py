from consumers.base_consumer import BaseConsumer

class SOSAlertConsumer(BaseConsumer):
    def __init__(self):
        super().__init__(group_id="SOS_Consumer_Group", partition=0)