FROM runpod/worker-comfyui:5.7.1-base

# Clone custom nodes explicitly (comfy-node-install silently fails for some)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack && \
    git clone https://github.com/ltdrdata/comfyui-impact-subpack && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus && \
    git clone https://github.com/cubiq/ComfyUI_InstantID

# Install requirements for each custom node (absolute paths, no WORKDIR dependency)
RUN cd /comfyui/custom_nodes/ComfyUI-Impact-Pack && \
    pip install -r requirements.txt && \
    python install.py
RUN cd /comfyui/custom_nodes/comfyui-impact-subpack && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
RUN cd /comfyui/custom_nodes/ComfyUI_IPAdapter_plus && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
RUN cd /comfyui/custom_nodes/ComfyUI_InstantID && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# Ensure insightface + onnxruntime-gpu are installed
RUN pip install insightface onnxruntime-gpu

# Copy handler and character class
COPY handler.py /handler.py
COPY comfyui_character.py /comfyui_character.py

CMD ["python", "-u", "/handler.py"]
