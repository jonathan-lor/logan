from pymongo import MongoClient


def connect_to_client(uri: str):

    client = MongoClient(uri)
    return client


