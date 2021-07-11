# 1.0 INTRODUCTION
Nowadays, in the era of digitalization, digital thermometer has replaced traditional temperature sensing thermometer. 
This is because traditional temperature sensing thermometers are not able to fulfil the high demand and requirement of 
efficiency and accuracy temperature measurement.
  
Digital temperature measurement is very important physical parameter in the industry as well as in modern advance 
technology research and development (R&D). Digital thermometer is an instrument used to measure the temperature. According 
to the Science Direct, a digital thermometer is used to verify a smart temperature transmitter under flowing conditions 
and a successful calibration of the smart temperature transmitter. 

The DHT11 is a commonly used as the temperature and humidity sensor in a simple circuit because the sensor can measure 
the temperature from 0°C to 50°C and humidity from 20% to 90% with an accuracy of ±1°C and ±1%. In term of power consumption, 
DHT11 has low power consumption and it is ultra-small size. The DHT11 sensor comes with a dedicated NTC to measure the 
surrounding temperature and humidity as well as an 8-bit microcontroller to output the values of temperature and humidity. 

# 2.0 PROJECT DESCRIPTION
In this digital thermometer project, DHT11 is used to act as our temperature and humidity sensor. The purpose of this 
project is to measure the temperature and humidity in our house. When the surrounding temperature exceed 30°C, a LED will 
light up to give us a signal to switch on the air-conditioner. Surrounding humidity is not a consideration in giving signal 
to switch on the are conditioner. So, this is the objective of this project.

Quartus II software is used to implement this digital thermometer project on CPLD. Verilog code is used to design the all 
the Datapath Unit, Control Unit, Top Level Module as well as testbench (to verify the DHT11 Verilog Code). All the Verilog 
code can be referred in APPENDIX. For DHT11, There are 7 states in DHT11 sensor, which is 
1.	S_POWER_ON 
2.	S_LOW_20MS 
3.	S_HIGH_20US 
4.	S_LOW_83US
5.	S_HIGH_87US
6.	S_SEND_DATA 
7.	S_DELAY

Next, in order to show the actual value of surrounding temperature and humidity, four 7 segment LED display is used in this 
project. The circuit design is shown in Figure 1.

![Capture](https://user-images.githubusercontent.com/87258961/125189937-3d23c880-e26d-11eb-9304-11e55d27170a.PNG)

The left two most of 7-segment LED display is used to display the value of surrounding humidity, while the right two most of 
7-segment LED display is used to display the value of surrounding temperature. All the four 7-segment LED display used in 
this project is common-cathode type. 

![image](https://user-images.githubusercontent.com/87258961/125189988-83792780-e26d-11eb-908a-36cbf3b5ee4a.png)

# 3.0 SOFTWARE
1.	Quartus II

# 4.0	HARDWARE
1.	DHT11 sensor
2.	CPLD
3.	Green LED
4.	Four 7-segment LED display
5.	Breadboard
6.	Male-to-male jumpers
7.	Male-to-female jumpers

# 5.0 SIMULATION AND RESULTS

![image](https://user-images.githubusercontent.com/87258961/125190151-2b8ef080-e26e-11eb-9bc5-adcb7fa43a5f.png)
