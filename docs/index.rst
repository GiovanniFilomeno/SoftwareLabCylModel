*******
Cylinder-based approximation of 3D objects
*******


Contributors 
^^^^^^^^

Students:
~~~~~~~~
* Ahmad M. Belbeisi 

* Cristian Saenz Betancourt 

* Chaudhry Taimoor Niaz 

* Benjamin Sundqvist 

Supervisors:
~~~~~~~~
* Giovanni Filomeno, M.Sc. 

* Moustafa Alsayed Ahmad, M.Sc. 

Introduction 
^^^^^^^^
The automotive industry faces increasingly strict regulations concerning fleet 
carbon emissions and pollutant emissions, which require innovative drive systems. A fleet containing a mix of conventional, hybrid and purely electric vehicles seems to be one likely answer to meet these requirements. To handle the space challenges of adding electrical components, transmission synthesis tools have been developed. The industry successfully applies them to synthesize transmissions for purely electric, conventional and hybrid powertrains. A complete evaluation of the transmission concept, however, requires design drafts. Therefore,
automatizing the transmission design process is the content of current research, focusing on a fast generation of design drafts for multiple transmission topologies found by the transmission synthesis.

3D objects may be approximated for later computational efficiency reasons for the computer-aided optimization of engineering designs. For instance, it may be beneficial to inner-approximate objects by coaxial cylinders. This task's goal is a model that uses a few cylinders while approximating the main features of the thing.

Task description  
~~~~~~~~
The first task is to import a 3D geometry from an STL file. This volume should then be approximated by cylinders. All these cylinders need to be parallel. They are defined to be parallel to the y-axis of the given geometry. Furthermore, the shape can be defined as an addition and a subtraction of cylinders. In the following, the added cylinders will be called green, and the subtracted cylinders will be called red. The approximation needs to lie entirely inside the original volume, as this volume should model a construction space for a transmission system. Therefore, it needs to be guaranteed that a point is inside the original volume if it is inside the approximation. The aim is to approximate the shape with as few cylinders as possible while approximating the main features of the geometry well. To evaluate the quality of the approximation, also the volume should be computed and compared to the original volume. The code is tested using multiple different STL-files. 

For a further details, please refer to :download:`the project report <img/project_report.pdf>`.

Running the code 
~~~~~~~~
The simplest way to use *Cylinder-based approximation of 3D objects* is through running the main file  
This can be achieved by executing the following command::

    cylinder_approximation_3D.m


2D Approximation
^^^^^^^^
.. toctree::
    :caption: 2D Approximation
    

    2D_approximation


3D Approximation
^^^^^^^^
.. toctree::
    :caption: 3D Approximation
    
    

    3D_approximation

STL Import
^^^^^^^^
.. toctree::
    :caption: STL Import
    
    

    stl_import

Visualization
^^^^^^^^
.. toctree::
    :caption: Visualization
    

    visualization


Reference
^^^^^^^^
.. toctree::
    :caption: Reference
    

    Reference

  
