
# Requre quartus project
package require ::quartus::project

# Set pin locations for LCD on GPIO 0
set_location_assignment PIN_AJ17 -to LT24Data[0]
set_location_assignment PIN_AJ19 -to LT24Data[1]
set_location_assignment PIN_AK19 -to LT24Data[2]
set_location_assignment PIN_AK18 -to LT24Data[3]
set_location_assignment PIN_AE16 -to LT24Data[4]
set_location_assignment PIN_AF16 -to LT24Data[5]
set_location_assignment PIN_AG17 -to LT24Data[6]
set_location_assignment PIN_AA18 -to LT24Data[7]
set_location_assignment PIN_AA19 -to LT24Data[8]
set_location_assignment PIN_AE17 -to LT24Data[9]
set_location_assignment PIN_AC20 -to LT24Data[10]
set_location_assignment PIN_AH19 -to LT24Data[11]
set_location_assignment PIN_AJ20 -to LT24Data[12]
set_location_assignment PIN_AH20 -to LT24Data[13]
set_location_assignment PIN_AK21 -to LT24Data[14]
set_location_assignment PIN_AD19 -to LT24Data[15]
set_location_assignment PIN_AG20 -to LT24Reset_n
set_location_assignment PIN_AG16 -to LT24RS
set_location_assignment PIN_AD20 -to LT24CS_n
set_location_assignment PIN_AH18 -to LT24Rd_n
set_location_assignment PIN_AH17 -to LT24Wr_n
set_location_assignment PIN_AJ21 -to LT24LCDOn

# Set pin location for Clock
set_location_assignment PIN_AA16 -to clock

# Set pin location for globalReset
set_location_assignment PIN_AA14 -to globalReset

# Set pin location for 7 segment displays

set_location_assignment PIN_AE26 -to seg1[0]
set_location_assignment PIN_AE27 -to seg1[1]
set_location_assignment PIN_AE28 -to seg1[2]
set_location_assignment PIN_AG27 -to seg1[3]
set_location_assignment PIN_AF28 -to seg1[4]
set_location_assignment PIN_AG28 -to seg1[5]
set_location_assignment PIN_AH28 -to seg1[6]

set_location_assignment PIN_AJ29 -to seg2[0]
set_location_assignment PIN_AH29 -to seg2[1]
set_location_assignment PIN_AH30 -to seg2[2]
set_location_assignment PIN_AG30 -to seg2[3]
set_location_assignment PIN_AF29 -to seg2[4]
set_location_assignment PIN_AF30 -to seg2[5]
set_location_assignment PIN_AD27 -to seg2[6]

set_location_assignment PIN_AB23 -to seg3[0]
set_location_assignment PIN_AE29 -to seg3[1]
set_location_assignment PIN_AD29 -to seg3[2]
set_location_assignment PIN_AC28 -to seg3[3]
set_location_assignment PIN_AD30 -to seg3[4]
set_location_assignment PIN_AC29 -to seg3[5]
set_location_assignment PIN_AC30 -to seg3[6]

set_location_assignment PIN_AD26 -to seg4[0]
set_location_assignment PIN_AC27 -to seg4[1]
set_location_assignment PIN_AD25 -to seg4[2]
set_location_assignment PIN_AC25 -to seg4[3]
set_location_assignment PIN_AB28 -to seg4[4]
set_location_assignment PIN_AB25 -to seg4[5]
set_location_assignment PIN_AB22 -to seg4[6]

set_location_assignment PIN_AA24 -to seg5[0]
set_location_assignment PIN_Y23 -to seg5[1]
set_location_assignment PIN_Y24 -to seg5[2]
set_location_assignment PIN_W22 -to seg5[3]
set_location_assignment PIN_W24 -to seg5[4]
set_location_assignment PIN_V23 -to seg5[5]
set_location_assignment PIN_W25 -to seg5[6]

set_location_assignment PIN_V25 -to seg6[0]
set_location_assignment PIN_AA28 -to seg6[1]
set_location_assignment PIN_Y27 -to seg6[2]
set_location_assignment PIN_AB27 -to seg6[3]
set_location_assignment PIN_AB26 -to seg6[4]
set_location_assignment PIN_AA26 -to seg6[5]
set_location_assignment PIN_AA25 -to seg6[6]

# Set pin location for resetApp
set_location_assignment PIN_Y21 -to resetApp

# Set Pin Location for Slide Button

set_location_assignment PIN_AB12 -to slide_button[0]
set_location_assignment PIN_AC12 -to slide_button[1]
set_location_assignment PIN_AF9  -to slide_button[2]

# Set Pin Location for Threshold Slide Buttons

set_location_assignment PIN_AF10 -to thres_switch[0]
set_location_assignment PIN_AD11 -to thres_switch[1]
set_location_assignment PIN_AD12 -to thres_switch[2]
set_location_assignment PIN_AE11 -to thres_switch[3]
set_location_assignment PIN_AC9  -to thres_switch[4]
set_location_assignment PIN_AD10 -to thres_switch[5]
set_location_assignment PIN_AE12 -to thres_switch[6]

# Set Pin Location for Push Button

set_location_assignment PIN_AA15 -to button2
set_location_assignment PIN_W15 -to button3

#Set Pin Location for debug LEDS

set_location_assignment PIN_W20 -to debug1
set_location_assignment PIN_W16 -to debug2
set_location_assignment PIN_V17 -to debug3
set_location_assignment PIN_V18 -to debug4

# Commit assignments
export_assignments
