from jinja2 import Environment, FileSystemLoader
import os
from models.notification_types_model import NotificationTypesEnum

class EmailTemplate:
    TEMPLATE_DIR = os.path.abspath('./templates/email')

    @staticmethod
    def get_email_template(event_type_id, recipient_full_name, message):
        env = Environment(loader=FileSystemLoader(EmailTemplate.TEMPLATE_DIR)) 
        template_map = {
            NotificationTypesEnum.SOS.value: "sos_email.html",
            NotificationTypesEnum.ADAPTIVE_LOCATION_ALERT.value: "adaptive_location_email.html",
            NotificationTypesEnum.TRAVEL_ALERT.value: "travel_alert_email.html",
            NotificationTypesEnum.GENERIC.value: "generic_email.html"
        }

        template_file = template_map.get(event_type_id, "generic_email.html")
        try:
            template = env.get_template(template_file)
            return template.render(recipient_full_name=recipient_full_name, message=message)
        except Exception as e:
            print(f"Error rendering email template: {e}")
            return None