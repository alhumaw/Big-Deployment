#! /usr/bin/env python3
from flask import Flask, render_template,url_for, make_response,send_from_directory
import sys
import requests
import json
import subprocess
import socket
import random


app = Flask(__name__)

cacheWeather = dict(link = "", weatherSave= "")
cacheAddress = dict(link = "", addressSave = "")

@app.route("/joke/")
def joke():
    url =  'https://icanhazdadjoke.com/'
    command = ['curl', '-H', '"Accept:', 'text/plain"', url]
    result = subprocess.run(command, capture_output=True, text=True)
    return result.stdout


@app.route("/weather/<ipurl>")
def weatherF(ipurl):
    global cacheWeather

    #checking if ip or url
    if ipurl.isalpha: 
        IP = socket.gethostbyname(ipurl)
    else:
        IP = ipurl
        #print(ipurl)
        #print(IP)
    # print(IP)
    # print(cacheWeather["link"])
    #checking cache
    if cacheWeather["link"] == IP:
        print("ip In cache")
        return cacheWeather["weatherSave"]
    else:
        print("ip NOT in cache")
        s,o = subprocess.getstatusoutput("whois " + IP)
        # print(o)
        #prev code from last assigement with minor changes to fit cashing
        for x in o.split("\n"):
            if x.startswith("Address: "):
                address = x.split("Address:")[1]
                address = address.strip()
                address = address.replace(' ', "+")
                print(address)
            if x.startswith("City: "):
                city = x.split("City: ")[1]
                city = city.strip()
                city = city.replace(' ', "+")
            if x.startswith("StateProv: "):
                sta = x.split("StateProv: ")[1]
                sta = sta.strip()
                sta = sta.replace(' ', "+")
            if x.startswith("PostalCode: "):
                aCode = x.split("PostalCode: ")[1]
                aCode = aCode.strip()
                aCode = aCode.replace(' ', "+")
            if x.startswith("Country: "):
                ctr = x.split("Country: ")[1]
                ctr = ctr.strip()
                ctr = ctr.replace(' ', "+")

        rawLocation = f'street={address}&city={city}&state={sta}&zip={aCode}'

        apiLocation = f'https://geocoding.geo.census.gov/geocoder/locations/address?{rawLocation}&benchmark=Public_AR_Census2020&format=json'
        
        response = requests.get(apiLocation)

        # convert it to json
        js = json.loads(response.text)
        # print(js)
        x = js['result']['addressMatches'][0]['coordinates']['x']
        y = js['result']['addressMatches'][0]['coordinates']['y']

        cords = str(y) + "," + str(x) 
        
        print(cords)

        # base API string for weather.gov
        weather_s = "https://api.weather.gov/points/"

        # sys.argv[1] gives us the command line input
        # sys.argv[0] is the name of the python file
        #print(weather_s+coords)

        # use the commandline input and the weather_s to make API call
        response = requests.get(weather_s+cords)

        # convert it to json
        js = json.loads(response.text)

        # find the forecast URL based on the API page
        forecast_URL = js['properties']['forecast']

        #print link that we use for next API call
        #print(forecast_URL)

        # call the API again to get theforecast
        final_response = requests.get(forecast_URL)

        #parse json
        js = json.loads(final_response.text)

        cacheWeather = dict(link = IP, weatherSave = js['properties']['periods'][0]['detailedForecast'])

        #print the forecast
        return (js['properties']['periods'][0]['detailedForecast'])



@app.route("/address/<ipurl>")
def addressF(ipurl):

    global cacheAddress

    if ipurl.isalpha: 
        IP = socket.gethostbyname(ipurl)
    else:
        IP = ipurl

    #print(ipurl)
    #print(IP)

    if cacheAddress["link"] == IP:
        print("ip IN cache")
        return cacheAddress["addressSave"]
    else:
        print("ip Not in cache")
        s,o = subprocess.getstatusoutput("whois " + IP)

        for x in o.split("\n"):
            if x.startswith("Address: "):
                address = x.split("Address:")[1]
                address = address.strip()
            if x.startswith("City: "):
                city = x.split("City: ")[1]
                city = city.strip()
            if x.startswith("StateProv: "):
                sta = x.split("StateProv: ")[1]
                sta = sta.strip()
            if x.startswith("PostalCode: "):
                aCode = x.split("PostalCode: ")[1]
                aCode = aCode.strip()
            if x.startswith("Country: "):
                ctr = x.split("Country: ")[1]
                ctr = ctr.strip()

        location = f'{address} {city} {sta} {aCode}'

        cacheAddress = dict(link = IP, addressSave = location)

        return location

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/ftp')
def ftp():
    return render_template('ftp.html')

@app.route('/static/css/style.css')
def style_css():
    response = make_response(render_template('style.css'))
    response.headers['Content-Type'] = 'text/css'
    return response

@app.route('/static/images/<path:filename>')
def serve_image(filename):
    return send_from_directory('static/images', filename)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
