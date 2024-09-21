import os
import json
import shutil
from pathlib import Path
from huggingface_hub import snapshot_download


HF_CONFIG_FILE = os.getenv("HF_CONFIG_FILE", "/hf.json")
HF_MODEL_REPO = os.getenv("HF_MODEL_REPO", "/models")


if __name__ == "__main__":
  file = Path(HF_CONFIG_FILE).expanduser().resolve()
  if not file.is_file():
    print("No huggingface config found!")
  else:
    repo = Path(HF_MODEL_REPO)
    repo.mkdir(parents=True, exist_ok=True)
    with file.open("r") as f:
      conf = json.load(f)
    token = conf.get("token", None)
    models = conf.get("models", [])
    for model in models:
      _name = model.get("name", None)
      assert _name is not None, "Invalid huggingface config! Model name cannot be none!"
      _token = model.get("token", token)
      _ref = model.get("ref", None)
      snapshot_download(repo_id=_name, revision=_ref, token=_token, local_dir=repo, ignore_patterns=[".*"])
    cache = Path(repo, ".cache")
    shutil.rmtree(cache)
