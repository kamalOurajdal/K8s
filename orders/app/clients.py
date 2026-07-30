import requests


class ServiceClient:
    def __init__(self, base_url, timeout):
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout

    def get(self, path):
        response = requests.get(f"{self.base_url}{path}", timeout=self.timeout)
        if response.status_code == 404:
            return None
        response.raise_for_status()
        return response.json()["data"]
    
    def post(self, path, data):
        response = requests.post(f"{self.base_url}{path}", json=data, timeout=self.timeout)
        if response.status_code == 404:
            return None
        response.raise_for_status()
        return response.json()["data"]
        

