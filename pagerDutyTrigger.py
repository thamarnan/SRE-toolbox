import json
import requests

def trigger_incident():

    ROUTING_KEY = "xxxxx" # ENTER EVENTS V2 API INTEGRATION KEY HERE

    header = {
        "Content-Type": "application/json"
    }

    payload = { # Payload is built with the least amount of fields required to trigger an incident
        "routing_key": ROUTING_KEY,
        "event_action": "trigger",
        "payload": {
            "summary": "SEV2 - Description ...",
            "source": "This alert is coming from....",
            "severity": "critical"
        }
    }

    response = requests.post('https://events.pagerduty.com/v2/enqueue', data=json.dumps(payload), headers=header)

    if response.json()["status"] == "success":
        print('Incident created with with dedup key (also known as incident / alert key) of ' + '"' + response.json()['dedup_key'] + '"')
    else:
        print(response.text) # print error message if not successful

if __name__ == '__main__':
    trigger_incident()
