import os
import json
import jinja2
import shutil
from pathlib import Path
from huggingface_hub import snapshot_download


CONFIG = os.getenv('HF_DOWNLOAD_CONF', '/conf.d/huggingface.json')
TRITON_MODEL_DIR = os.getenv('TRITON_MODEL_DIR', '/models')


if __name__ == '__main__':
  print("DOWNLOAD MODELS FROM HUGGINGFACE HUB!")
  # Make sure triton model directory exist.
  triton_model_dir = Path(TRITON_MODEL_DIR)
  triton_model_dir.mkdir(parents=True, exist_ok=True)
  # Read and parse config. 
  # Config can be file or json string from HF_CONFIG var.
  f = Path(CONFIG).expanduser().resolve()
  try:
    c = json.loads(jinja2.Template(f.open('r').read() if f.is_file() else CONFIG).render(os.environ))
  except:
    print('NO HUGGINGFACE CONFIG!')
    exit(0)
  # Download models.
  token, models = c.get('token', None), c.get('models', [])
  for model in models:
    snapshot_download(
      repo_id=model.get('name'), 
      revision=model.get('ref'),
      token=model.get('token', token),
      local_dir=triton_model_dir,
      ignore_patterns=[".*"].extend(model.get('ignore', [])))
  # Delete cache folder.
  shutil.rmtree(Path(triton_model_dir, '.cache'))