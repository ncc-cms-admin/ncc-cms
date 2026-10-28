FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /srv/ncc-cms
RUN useradd --create-home --uid 10001 appuser
COPY ncc-cms-source.zip /tmp/ncc-cms-source.zip
RUN python -c "import zipfile; zipfile.ZipFile('/tmp/ncc-cms-source.zip').extractall('/srv/ncc-cms')" \
    && pip install --no-cache-dir -r requirements.txt \
    && mkdir -p /srv/ncc-cms/private_uploads \
    && chown -R appuser:appuser /srv/ncc-cms \
    && rm -f /tmp/ncc-cms-source.zip
USER appuser
EXPOSE 8000
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000} --proxy-headers"]
