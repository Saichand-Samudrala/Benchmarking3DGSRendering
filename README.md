If you use this repository, please cite:

S. Samudrala, S. Kondguli and P. Gratz, "Benchmarking 3D Gaussian Splatting Rendering," 2025 IEEE International Symposium on Performance Analysis of Systems and Software (ISPASS), Ghent, Belgium, 2025, pp. 227-238, doi: 10.1109/ISPASS64960.2025.00029.

@INPROCEEDINGS{11096354,
  author={Samudrala, Saichand and Kondguli, Sushant and Gratz, Paul},
  booktitle={2025 IEEE International Symposium on Performance Analysis of Systems and Software (ISPASS)}, 
  title={Benchmarking 3D Gaussian Splatting Rendering}, 
  year={2025},
  volume={},
  number={},
  pages={227-238},
  keywords={Image quality;Training;Solid modeling;Three-dimensional displays;Graphics processing units;Manuals;Benchmark testing;Rendering (computer graphics);Hardware;Synchronization},
  doi={10.1109/ISPASS64960.2025.00029}}


# Benchmarking 3D Gaussian Splatting (3DGS) Rendering
## OS: Linux Ubuntu

<details>
<summary>3DGS Training Data Generation</summary>
 
1. Download and extract [Godot 4.3](https://godotengine.org/) game engine executable file.
2. Download 3D models in .glb, .fbx, or other formats supported by Godot such as below.  
[Stanford Dragon (SD)](https://sketchfab.com/3d-models/stanford-dragon-sss-test-d6b85e8dc4b54269b3df6c7e1e5541ba)|  	
[Stanford Armadillo (SA)](https://sketchfab.com/3d-models/stanford-armadillo-pbr-a2ee830d2fca4a0f92a3297a4d84c15f)| 	
[Stanford Bunny (SB)](https://sketchfab.com/3d-models/stanford-bunny-pbr-42c9bdc4d27a418daa19b2d5ff690095)| 	
[Table Bonsai (TB)](https://sketchfab.com/3d-models/table-bonsai-scene-ba5c03d8aff24231945cbea6d8b0ae81)|
[Sponza (SP)](https://sketchfab.com/3d-models/sponza-0cbee5e07f3a4fae95be8b3a036abc91)| 
[Garden Table (GT)](https://sketchfab.com/3d-models/garden-table-scene-657ad464d6e347e48cf52e12c18977ad)| 
[Train (TRN)](https://sketchfab.com/3d-models/emd-gp7-western-pacific-713-1c89cb9f2c224b78b6fea50f82e042c3)| 	
[Sibenik (SBNK)](https://sketchfab.com/3d-models/sibenik-cathedral-vray-fbx-7dae769f0321475f9ac8264d5d296ba6)| 	
[ABeautifulGame (ABG)](https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/ABeautifulGame)| 	
[Morgan’s Manor (MM)](https://sketchfab.com/3d-models/morgans-manor-85aeb4d97f614007b6cacb292ae03e44)|	
[Spot (SPT)](https://www.cs.cmu.edu/~kmcrane/Projects/ModelRepository/)| 	
[Romani Wagon (RW)](https://sketchfab.com/3d-models/romani-wagon-2-f30144f7f9fa4a9dbaa99602e8a5b9bb) 
3. Run the Godot executable file and create a new Forward+ project.  
4. Create a 3D scene "X" and add an environment, sun, and a camera3D to the scene.
   - Select "3D scene" in the scene menu
   - You will observe a Node3D is created in the scene menu
   - Click on the three verticle dots icon on the top to open a drop down menu
   - In the drop down click on "Add Sun to Scene" and "Add Environment to Scene".
5. Import scene:
   - Copy the downloaded scene to your project directory. It will show up under res:// in the FileSystem Panel
6. Click on the "Scene" menu and create another scene "Y"
7. Import (drag) the 3D model into the scene "Y". 
8. Set the scene "X" created in 4 as the main scene.
9. Under the scene panel, right click on Node3D and select “Instantiate Child Scene”. Select the “Y” scene. You will see new Node3D added as a child to the main scene.
10. Adjust the postion of the camera3D in the environment so the scene is clearly visible in the viewport.
11. Adding Sky material:
    - Right click WorldEnvironment -> SubResources -> Environment
    - In the Inspectory Panel on the right, click on ‘Sky’
    - Select PanoramaSkyMaterial as Sky Material
    - Import an .exr HDRI such as [overcast_soil](https://polyhaven.com/a/overcast_soil). This lights up the scene in all directions.
12. In the project settings menu, turn on the advanced settings and set the display window viewport width and height to 1600 and 900, respectively.
13. Turn on window transparency options.
14. Attach the required camera script (available in Godot_Scripts folder) to the camera3D node for image capture. Refer to the scripts provided in the folder...
15. Click the project run button to capture images for the given configuration. Modify the configuration in the scripts and rerun to capture images from various angles and heights.
16. Repeat step 15 until the captured images cover the entire model, top to bottom, and in all directions.
17. These images are further processed using [Colmap](https://colmap.github.io/) to extract Structure-from-Motion (SfM) information that is used to create 3DGS point cloud. More details are discussed in the following sections.
    
</details>

<details>
<summary> Game executable file creation for traditional graphics (TG) rendering </summary>
 
1. Use the same Godot project created in 3DGS Training Data Generation for creating the game executable file.
2. Create a new label in the main scene and name it as FPSCounter and attach the "fps_counter" script provided in this repository
3. Attach the "scene_navigation" script to the camera3D in the project
4. In the project settings, disable "VSYNC" and also provide input map (keys) from "scene_navigation" script.
5. Export the executable file using the project, export menu.
</details>

## Frameworks Setup
### 3DGS 
<details>
<summary><b>Commands to install the <a href="https://github.com/graphdeco-inria/gaussian-splatting">3DGS</a> framework</b></summary>

1. [CUDA 11.7](https://developer.nvidia.com/cuda-11-7-0-download-archive) installation
   ```bash
   wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda_11.7.0_515.43.04_linux.run
   sudo sh cuda_11.7.0_515.43.04_linux.run --silent --driver
   export PATH=/usr/local/cuda-11.7/bin${PATH:+:${PATH}}
   export LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
   nvcc --version
   ```
 
2. [Conda](https://www.anaconda.com/docs/getting-started/miniconda/install#linux) installation
   ```bash
   mkdir -p ~/miniconda3
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
   bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
   rm ~/miniconda3/miniconda.sh
   source ~/miniconda3/bin/activate
   conda init --all
   ```
3. [Colmap](https://colmap.github.io/) installation
   ```bash
   sudo apt install colmap
   which colmap
   ```
4. [Imagemagick](https://imagemagick.org/) installation
   ```bash
   sudo apt install imagemagick
   convert -version
   ```
5. Clone the [3DGS](https://github.com/graphdeco-inria/gaussian-splatting) repository and cd into it
   ```bash
   git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive .
   cd gaussian_splatting/
   ```
6. Create a conda environment
   ```bash
   conda create -n gaussian_splatting python=3.7
   conda activate gaussian_splatting
   conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia
   ```
7. Install submodules and other dependencies
   ```bash
   sudo apt install pip
   pip install submodules/diff-gaussian-rasterization
   pip install submodules/simple-knn
   pip install submodules/fused-ssim
   pip install plyfile
   pip install tqdm
   pip install Pillow
   pip install opencv-python
   ```
8. Preparing images for the 3DGS point cloud generation
   - Copy the images from the 3DGS Training Data Generation into a folder called "input" and then copy the "input" folder into another folder called "data."
   ```bash
   python convert.py -s <path to the data folder>
   ```
9. Train the 3DGS model and create a point cloud
   ```bash
   python train.py -s data --eval # --data_device cpu to run on the cpu
   ```
   - A folder containing the point cloud will be created in the gaussian_splatting/output folder
</details>

### Vkgs
<details>
<summary><b>Commands to install the <a href="https://github.com/jaesung-cs/vkgs">Vkgs</a> renderer</b></summary>
 
1. Install the latest nvidia drivers
   ```bash
   sudo apt --purge remove '*nvidia*'
   sudo apt autoremove
   uname -r
   apt search linux-modules-nvidia | grep 6.8.0-57-generic
   sudo apt install linux-modules-nvidia-550-6.8.0-57-generic nvidia-driver-550
   ```
2. Install [VulkanSDK](https://vulkan.lunarg.com/)>=1.3.296.0
   - Install dependencies
   ```bash
   sudo apt update
   sudo apt upgrade
   sudo apt install libxcb-xinput0 libxcb-xinerama0 libxcb-cursor-dev libwayland-dev qtbase5-dev libxinerama-dev
   ```
   - Download the [Vulkan SDK](https://vulkan.lunarg.com/sdk/home#linux) tarball
   ```bash
   cd ~
   mkdir vulkan
   cd vulkan
   sha256sum $HOME/Downloads/vulkansdk-linux-x86_64-1.x.yy.z.tar.xz # Assuming the tarball is in $HOME/Downloads
   tar xf $HOME/Downloads/vulkansdk-linux-x86_64-1.x.yy.z.tar.xz # Assuming the tarball is in $HOME/Downloads
   ```
   - Check for Vulkan driver installation for your GPU by verifying a .json file in the locations /etc/vulkan/icd.d/ or /usr/share/vulkan/icd.d
   - Set up the runtime environment variables
   ```bash
   export VULKAN_SDK=~/vulkan/1.x.yy.z/x86_64 
   export PATH=$VULKAN_SDK/bin:$PATH
   export LD_LIBRARY_PATH=$VULKAN_SDK/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
   export VK_ADD_LAYER_PATH=$VULKAN_SDK/share/vulkan/explicit_layer.d
   ```
   - Copy SDK files to the system directories
   ```bash
   sudo cp -r $VULKAN_SDK/include/vulkan/ /usr/local/include/ # Vulkan Header Files
   sudo cp -P $VULKAN_SDK/lib/libvulkan.so* /usr/local/lib/   # Vulkan Loader Files
   sudo cp $VULKAN_SDK/lib/libVkLayer_*.so /usr/local/lib/    # Vulkan Layer Files
   sudo mkdir -p /usr/local/share/vulkan/explicit_layer.d     # Vulkan Layer Files
   sudo cp $VULKAN_SDK/share/vulkan/explicit_layer.d/VkLayer_*.json /usr/local/share/vulkan/explicit_layer.d # Vulkan Layer Files
   sudo ldconfig # Refresh system loader search cache
   ```
   - Verify the installation
   ```bash
   vulkaninfo
   vkcube
   ```
3. Clone the Vkgs git repository
   ```bash
   git clone https://github.com/jaesung-cs/vkgs.git --recursive
   ```
4. Vkgs submodules
   ```bash
   git submodule update --init --recursive
   ```
5. Build 
   ```bash
   cd vkgs
   cmake . -B build
   cmake --build build --config Release -j
   ```
6. If you see slangc build failure install it and rebuild (follow step 5.)
   Download latest slang-*-linux-x86_64.tar.gz from GitHub releases
   ```bash
   tar xf slang-*-linux-x86_64.tar.gz
   export PATH=$PATH:/path/to/slang-*/bin
   slangc -version
   cmake . -B build && cmake --build build --config Release -j
   ```
7. Run
   ```bash
   ./build/vkgs_viewer -i <ply_filepath>
   ```
</details>
<br>

## Tools/Performance Profiling
<details>
<summary><b>Commands to install the <a href="https://github.com/rbonghi/jetson_stats">nvidia-smi</a></b></summary>
 
- Remove existing and install the latest nvidia driver
  ```bash
  sudo apt purge nvidia-driver-570 # Modify the driver version as required
  sudo apt autoremove -y
  sudo apt autoclean
  sudo apt remove nvidia-cuda-toolkit
  sudo apt install nvidia-driver-570 # Modify the driver version as required
  sudo apt install nvidia-cuda-toolkit
  nvcc --version
  nvidia-smi
  ```
- To set the power limit of the GPU
  ```bash
  sudo nvidia-smi -pl 60
  ```
</details>

<details>
<summary><b>Commands to install the <a href="https://github.com/Syllo/nvtop">NVTOP</a></b></summary>
 
```bash
sudo apt install nvtop
nvtop
```
</details>

<details>
<summary><b>Commands to install the <a href="https://github.com/rbonghi/jetson_stats">Jetson_stats</a></b></summary>
 
```bash
sudo pip3 install -U jetson-stats
jtop
```
</details>

<details>
<summary><b>Commands to install the <a href="https://docs.nvidia.com/nsight-graphics/InstallationGuide/index.html">Nsight Graphics</a></b></summary>
 
- Download [Nsight Graphics](https://developer.nvidia.com/tools-downloads) .deb file
- Install
```bash
sudo dpkg -i NVIDIA_Nsight_Graphics_2024.2.1.24281.deb
sudo /usr/bin/ngfx-ui-for-linux
```
- Run GPU trace profiler from the Night Graphics GUI
</details>
