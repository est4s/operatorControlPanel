# operatorControlPanel
Operator Panel Representation of Hydrulic Guillotine Shearing Machine in Matlab
 
 ![1-main](https://user-images.githubusercontent.com/53571773/124385887-64fcb480-dce0-11eb-9a74-a0d5287b6faf.JPG)
 
        
A Matlab App Designer application is developed for the control system calculations. 
The values entered by the operator:
1.	Material
2.	Thickness
3.	Length
Calculated values by the application for the entered workpiece:
1.	Cutting force
2.	Clamping force
3.	Hydraulic clamping circuit working pressure
4.	Stroke
5.	Rack angle
6.	Position difference between linear potentiometers
7.	Clearance
8.	The angle eccentric shaft should turn to reach the clearance


![2-material](https://user-images.githubusercontent.com/53571773/124385897-70e87680-dce0-11eb-9c41-aae013021920.JPG)

     The material selection tab is given above. The materials are added to use different clearance allowance constants. As the materials are chosen, the ultimate tensile strength and clearance allowance constant values are taken by program accordingly.
     
 ![3-length and thickness](https://user-images.githubusercontent.com/53571773/124385913-8198ec80-dce0-11eb-8559-60f3105016a1.JPG)
       
The length and thickness of the workpiece is entered in “length and thickness” tab. Thickness value is used to calculate the rack angle and cutting force. Length is used to calculate the stroke according to rack angle and thickness.
Rack angle is set by the application. As the cutting force formula is,
 
when the thickness is known, the unknowns are the cutting force and the rack angle. Because unnecessary rack angle causes deflection on the cut face, the rack angle should be as low as possible. Therefore, the application is optimized for that. 

![image](https://user-images.githubusercontent.com/53571773/124385941-94132600-dce0-11eb-89b9-0ffb33d5764c.png)
       
The piece of code given in the figure tries every angle in the defined rack angle array(which has a step of 0.1 degree) and finds the smallest angle that the machine can cut the workpiece. 

![7-warning](https://user-images.githubusercontent.com/53571773/124385992-c755b500-dce0-11eb-97c9-0fe495d0d1cc.JPG)
        
If the machine can not cut the workpiece, it pops up a warning dialog box.

![4-hyraulic](https://user-images.githubusercontent.com/53571773/124386004-d9375800-dce0-11eb-967f-74e1290298b1.JPG)
        
In “Hydraulic” tab, calculated stroke and clamping pressure are displayed. Clamping pressure is calculated using cutting force and clamping cylinder properties. 

![5-other](https://user-images.githubusercontent.com/53571773/124386016-e48a8380-dce0-11eb-9e13-65d09b58bda9.JPG)
        
In the “Other” section, eccentric shaft angle, cutting force, clamping force and position sensor difference are displayed. 

![image](https://user-images.githubusercontent.com/53571773/124386047-02f07f00-dce1-11eb-843d-1a524b6841a2.png)
        
The angle for the eccentric shaft is calculated by solving it for θ the following formula is used:
 e= 2 mm
b= 140 mm
 
![6-proportional valve](https://user-images.githubusercontent.com/53571773/124386025-ef451880-dce0-11eb-8d68-6a44fb5466d9.JPG)
        MATLAB App Designer Application: Proportional Valve Section
Proportional valve tab is to illustrate the proportional valves behavior against position data read from the sensors. For example, if the right hydraulic cylinder moves faster and accordingly the difference is positive, then its proportional valve slows the current until they are in the correct height with the other cylinder.
