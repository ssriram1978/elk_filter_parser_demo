# !/usr/bin/env python3
import datetime
import logging
import os
import sys
import time
import traceback
import json
import datetime


logging.basicConfig(format='%(message)s',
                    level=logging.INFO)


def import_all_paths():
    realpath = os.path.realpath(__file__)
    # print("os.path.realpath({})={}".format(__file__,realpath)`)
    dirname = os.path.dirname(realpath)
    # print("os.path.dirname({})={}".format(realpath,dirname))
    dirname_list = dirname.split('/')
    # print(dirname_list)
    for index in range(len(dirname_list)):
        module_path = '/'.join(dirname_list[:index])
        # print("module_path={}".format(module_path))
        try:
            sys.path.append(module_path)
        except:
            # print("Invalid module path {}".format(module_path))
            pass


import_all_paths()


class Plotter:
    """
        This Class is used to plot latency vs timestamp.
    """

    def __init__(self):
        """
        Initialize the class instance variables.
        """
        pass

    def perform_job(self):
        with open('timestamp_latency_sample.txt') as f:
            for line in f:
                dict_of_items = json.loads(line)
                for key, list_of_values in dict_of_items.items():
                    for value in list_of_values:
                        logging.info("Sent_timestamp:{},Latency_in_milliseconds:{}".format(key,value))
                time.sleep(5)

    def cleanup(self):
        pass


if __name__ == '__main__':
    plotter = Plotter()
    try:
        while True:
            plotter.perform_job()
            time.sleep(10)
    except KeyboardInterrupt:
        logging.error("Keyboard interrupt." + sys.exc_info()[0])
        logging.error("Exception in user code:")
        logging.error("-" * 60)
        traceback.print_exc(file=sys.stdout)
        logging.error("-" * 60)
