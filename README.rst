.. code-block:: console

   git clone https://github.com/simonpintarelli/sirius-docker-jupyterlab
   docker build . -t sirius-python
   docker run -v /some/path/on/your/machine:/home/user/sirius_files -p 8889:8888 sirius-python:latest


TODO: add more documentation...
