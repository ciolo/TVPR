# TVPR
Top View Person Re-identification using **Local Binary Pattern TOP **(http://www.scholarpedia.org/article/Local_Binary_Patterns#Spatiotemporal_LBP)

Dataset (http://vrai.dii.univpm.it/re-id-dataset)

**Person re-identification** is an important topic in scene monitoring, human computer interaction, retail, people counting, ambient assisted living and many other computer vision research.
The TVPR dataset stores depth frames (640x480) collected using *Asus Xtion Pro Live* in *top-view* configuration. This setup choice is primarily due to the reduction of occlusion and it has also the advantage of being privacy preserving, because faces are not recorded by the camera. The use of an RGB-D camera allow to extract anthropometric features for the recognition of people passing under the camera.

# Requirements

** Python dependences: numpy, openni, png  **
You must have this hierarchy:
MainFolder
|--core  
|--Top-view-TVPR
|--img

0. To Extract frames from .oni videos run "core/readerOni/readerONI.py".
After this the hierarchy become:
MainFolder
|--core  
|--Top-view-TVPR
|--img
   |--g001
   |-- ...  
   |--g022     

N.B. We had to try hard for this step, so we provide "/img" folder with frames already extracted from videos.

1. Classifie persons, running "core/step1_ClassifiePersons.m". After this the hierarchy become:
MainFolder
|--core  
|--Top-view-TVPR
|--img
   |--g001
      |--p001
      |-- ...
      |--p0x
   |-- ...    

2. Run "core/step2_Normalize.m" to detect central frame, normalize, cut and translate. The hierarchy add "/Normalize" folder under all "/p0x" folders, containing all info extracted in this step.

3. Run "core/step3_LBPPlanes.m" that extracts XY, XT and YT planes for every subject, and store this information in "/dataset". After this the hierarchy become:
MainFolder
|--core  
|--Top-view-TVPR
|--img
   |-- ...
|-- dataset

N.B. We provide "/dataset" folder with models already extracted from persons for a quick check.

4. Run "core/step4_compare.m" to compare subjects in videos and get a score.
