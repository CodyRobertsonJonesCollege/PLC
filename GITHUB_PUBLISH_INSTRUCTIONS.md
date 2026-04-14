# Publish the standalone QTI repo so it appears on GitHub

This PLC workspace cannot directly create GitHub repositories without your credentials.
Use the helper script to publish the standalone repo at `/workspace/qti-converter`.

## 1) Set credentials and owner

```bash
export GITHUB_TOKEN='<your_personal_access_token>'
export GITHUB_OWNER='CodyRobertsonJonesCollege'
export GITHUB_REPO='qti-converter'
export VISIBILITY='public'   # or private
```

## 2) Run publisher

```bash
bash scripts/publish_qti_repo_to_github.sh
```

## 3) Confirm

Open:

- `https://github.com/CodyRobertsonJonesCollege?tab=repositories`

You should see `qti-converter` listed there.
