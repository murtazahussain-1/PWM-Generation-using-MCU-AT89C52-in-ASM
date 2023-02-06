# PWM-Generation-using-MCU-AT89C52-in-ASM
A PWM generator code written in ARM assembly for MCU AT89C52

The user is asked the following 3 questions on an LCD and the user inputs using a keypad.
• Frequency of PWM
• Duty cycle
• Wave life (for how long the wave will exist)

Then all the necessary calculations are done and the PWM is sent to pin.
The status of the wave life is also displayed on the LCD.

# Circuit Diagrams
![image](https://user-images.githubusercontent.com/118768714/217036466-825e7449-49cd-4b39-b736-4bc272ec5586.png)
![image](https://user-images.githubusercontent.com/118768714/217036581-0782cbb4-6555-4860-918a-6f5144451a90.png)


# Main Modules:
	• Introduction
	• Input of Frequency
	• Input of Duty Cycle
	• Input of Wave Life
	• Calculation of Delays
	• Main Screen and process repetition

## INTRODUCTION:
We have two main subroutines called “command writer” and “data writer”. If we want to write a command (such as initialization commands) on the LCD we use the command writer subroutine. If we want to print something on the LCD we use the data writer subroutine.

For writing a R/W must be set to zero. For reading from the LCD this register must be set to high logic. For writing a command RS register must be set to low and for writing data this register must be set to high.

The strings of our names and roll numbers have been stored in the bottom of the code.

## INPUT OF FREQUENCY:
Now we move onto the next screen. Here the program asks the user to input the frequency. The user has to make 4 entries no matter what. For example, if the user wants to enter 344Hz, then he would have to enter 0344, otherwise, the program will show an error. After entering the frequency, user has to press # key to proceed further, our program will check whether the given frequency lies in the given range or not. If it doesn’t lie in the range, we will jump back on this module to input the frequency again. If it lies in the range (100-1000Hz), then we will convert the individual bits into a single 16-bit number. Using this formula:

C3=MSB, C0=LSB
16-bit number frequency = C3 x 1000 + C2 x 100 + C1 x 10 + C0

## INPUT OF DUTY CYCLE:
The duty cycle is entered in the same manner, we take the individual bits concatenate them, check them whether they lie in the range or not. If not, then the Program Counter is sent back else our program proceeds further.

## INPUT OF WAVE LIFE:
The Wave Life is entered in the same manner, we take the individual bits concatenate them, check them whether they lie in the range or not. If not, then the Program Counter is sent back else our program proceeds further.

## Calculation of Delays:
We have the frequency and the duty cycle, we can now calculate the on time and the off time for our PWM signal, this process is a back-end process. We use this formula:

starting point of timer=65536-(Duty cycle in % ×9216)/frequency

For calculating the on time the duty cycle will be entered in the above formula. For calculating the off time 100 minus the Duty Cycle will be entered in the place of Duty Cycle. These Two values will be saved.

Same procedure will be followed for the Wave Life. A point must be kept in mind that the timer 0 will control the on and off time of the PWM signal whereas the timer 1 will regulate the total wave life.

For 16 bit calculations a 16-bit divider and a 16-bit subtractor have been made.

## Main Screen and process repetition:
Now this screen will be displayed on the LCD, in this screen the frequency, the duty cycle, the total wave life and the time remaining will be displayed. As soon the wave life ends, a completion message will be displayed and then we will move back to enter the frequency subroutine. We did this so that we can test multiple PWMs instead of resetting the device again and again.

# Simulation Image
![image](https://user-images.githubusercontent.com/118768714/217037461-3e4af69b-b5f2-4db3-bfef-5e1232e1126e.png)
