
# Cylinder-based approximation of 3D objects

 
The automotive industry faces increasingly strict regulations concerning fleet CO<sub>2</sub>  and pollutant emissions, which require innovative drive systems. To meet
these requirements, a fleet containing a mix of conventional, hybrid and purely electric vehicles seems to be one likely answer. To handle the space challenges that the adding of electrical components produce, transmission synthesis tools have been developed. The industry successfully applies them to synthesize transmissions for purely electric, conventional and hybrid powertrains. A full evaluation of the transmission concept, however, requires design drafts. Therefore,
automatizing the transmission design process is the content of current research, focusing on a fast generation of design drafts for multiple transmission topologies found by the transmission synthesis.


For the computer-aided optimization of engineering designs, 3D-objects may be
approximated for later computational efficiency reasons. For instance, it may be
beneficial to inner-approximate objects by coaxial cylinders. This task's goal is a
model that uses few cylinders while approximating the main features of the object
(e.g., edges/surfaces) well.




Overview of Task
--------------------
* Develop an efficient algorithm for defining the sampled cylinders that approximate an object defined by an STL file. Therefore, you will:
* Create an STL file reader
* Define and implement an algorithm to identify the significant edges in the cross-section area (orthogonal to a specified axis-direction)
* Define and implement an algorithm for sampling the cross-section area using circles - Criteria may include respecting the identified edges, high area coverage, the number of circles used
* Use a computational-geometry library to calculate the intersection between the defined cylinders and the object and compare its volume to the object's original volume.
* Test the implementation using exemplary STL files


Installation
============

1. Clone the repository and made updates as detailed above
1. Make sure you have MATLAB_R2018b
1. Install Parallel Computing Toolbox from mathworks
1. Run cylinder_approximation_3D.m




## Contributors ✨

Thanks goes to these wonderful people:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/Ahmadbelbeisi"><img src="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/blob/main/Images/Ahmad.jpeg?raw=true" width="100px;" alt=""/><br /><sub><b>Ahmad M. Belbeisi</b></sub></a><br /><a href="#question-kentcdodds" title="Answering Questions">💬</a> <a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=Ahmadbelbeisi" title="Documentation">📖</a> <a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=Ahmadbelbeisi" title="Reviewed Pull Requests">👀</a> <a href="#talk-kentcdodds" title="Talks">📢</a></td>    
    <td align="center"><a href="https://github.com/benniqvist"><img src="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/blob/main/Images/BEN.jpeg?raw=true" width="100px;" alt=""/><br /><sub><b>Benjamin Sundqvist</b></sub></a><br /><a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=benniqvist" title="Documentation">📖</a> <a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=benniqvist" title="Reviewed Pull Requests">👀</a> <a href="#tool-jfmengels" title="code">🔧</a></td>
    <td align="center"><a href="https://github.com/cristiansaenzb"><img src="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/blob/main/Images/Camilo%20SB.jpeg?raw=true" width="100px;" alt=""/><br /><sub><b>Cristian Camilo Saenz Betancourt </b></sub></a><br /><a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=cristiansaenzb" title="Documentation">📖</a> <a href="#tool-jakebolam" title="code">🔧</a> <a href="#infra-jakebolam" </td>
    <td align="center"><a href="https://github.com/chtaimoor"><img src="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/blob/main/Images/Taimor.jpeg?raw=true" width="100px;" alt=""/><br /><sub><b>Chaudhry Taimoor Niaz</b></sub></a><br /><a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=chtaimoor" title="Documentation">📖</a> <a href="#tool-jakebolam" title="code">🔧</a> <a href="#infra-jakebolam" </td>
    <td align="center"><a href="https://github.com/GiovanniFilomeno"><img src="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/blob/main/Images/GiovanniFilomeno.jpeg?raw=true" width="100px;" alt=""/><br /><sub><b>Giovanni Filomeno</b></sub></a><br /><a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=GiovanniFilomeno" title="Event Organizer">📋</a> <a href="#tool-jakebolam" title="Mentor">🧑‍🏫</a> <a href="#infra-jakebolam"  <a href="#maintenance-jakebolam" title="projectManagement">📆 </a> <a href="https://github.com/GiovanniFilomeno/SoftwareLabCylModel/commits?author=GiovanniFilomeno" 

  </tr>
</table>





<hr>
<body class="sponsored">

<h2 class="centered"> Research in collaboration with</h2>


<table >
  <tr >
    <td ><a class="greyed" href="https://www.tum.de/" target="_blank"> <img src="https://www.ipt.med.tum.de/sites/default/files/redaktion/grafiken/header/logotum_neu.png?fid=111"  alt="1" width = 250px ></a></td>
    <td><a class="greyed" href="https://www.bmwgroup.com/de.html" target="_blank"><img src="https://www.bayern-innovativ.de/services/kkxqi/u4gj6?id=407b9544-cb84-4e30-bc03-ffcd5d6f9307&tn=1&s=logo&anon=1" alt="2" width = 250px ></a></td>

   </tr> 
   <tr>
    

     
  </tr>
</table>
</body>




## References:
- [A comprehensive process of reverse engineering from 3D meshes to CAD models](https://github.com/GiovanniFilomeno/SoftwareLabCylModel/blob/main/literature%20review/3d%20meshes%20to%20cad%20models.pdf) - 




Citing Cylinder-based approximation of 3D objects
==============


There is a `poster about Cylinder-based approximation of 3D objects `_!

If you are using our work  in your scientific research, please help our scientific
visibility by citing our work!


 

