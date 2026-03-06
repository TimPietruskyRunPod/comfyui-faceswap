# RunPod serverless handler for ComfyUI character generation.
# Wraps ComfyUICharacter with lazy initialization on first request.
import logging
import os
import sys

import runpod

# Ensure handler's directory is on the Python path so comfyui_character is importable
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(name)s] %(message)s")
logger = logging.getLogger(__name__)

worker = None


def handler(job):
    global worker
    if worker is None:
        logger.info("First request — initializing ComfyUICharacter...")
        from comfyui_character import ComfyUICharacter

        worker = ComfyUICharacter()
        logger.info("ComfyUICharacter ready")

    return worker.generate(job["input"])


runpod.serverless.start({"handler": handler})
