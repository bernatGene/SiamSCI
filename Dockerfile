RUN set -xe  \
	&& echo '#!/bin/sh' > /usr/sbin/policy-rc.d  \
	&& echo 'exit 101' >> /usr/sbin/policy-rc.d  \
	&& chmod +x /usr/sbin/policy-rc.d  \
	&& dpkg-divert --local --rename --add /sbin/initctl  \
	&& cp -a /usr/sbin/policy-rc.d /sbin/initctl  \
	&& sed -i 's/^exit.*/exit 0/' /sbin/initctl  \
	&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup  \
	&& echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean  \
	&& echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean  \
	&& echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean  \
	&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages  \
	&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes  \
	&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
RUN [ -z "$(apt-get indextargets)" ]
RUN mkdir -p /run/systemd  \
	&& echo 'docker' > /run/systemd/container
CMD ["/bin/bash"]
LABEL maintainer=NVIDIA CORPORATION <cudatools@nvidia.com>
RUN RUN apt-get update  \
	&& apt-get install -y --no-install-recommends gnupg2 curl ca-certificates  \
	&& curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add -  \
	&& echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list  \
	&& echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list  \
	&& apt-get purge --autoremove -y curl  \
	&& rm -rf /var/lib/apt/lists/* # buildkit
ENV CUDA_VERSION=11.0.3
RUN RUN apt-get update  \
	&& apt-get install -y --no-install-recommends cuda-cudart-11-0=11.0.221-1 cuda-compat-11-0  \
	&& ln -s cuda-11.0 /usr/local/cuda  \
	&& rm -rf /var/lib/apt/lists/* # buildkit
RUN RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf  \
	&& echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf # buildkit
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA=cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451
ARG ARCH
ARG CUDA
ARG CUDNN=8.0.4.30-1
ARG CUDNN_MAJOR_VERSION=8
ARG LIB_DIR_PREFIX=x86_64
ARG LIBNVINFER=7.1.3-1
ARG LIBNVINFER_MAJOR_VERSION=7
/bin/bash -c #(nop) SHELL [/bin/bash -c]
|7 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 /bin/bash -c apt-get update  \
	&& apt-get install -y --no-install-recommends build-essential cuda-command-line-tools-${CUDA/./-} libcublas-${CUDA/./-} cuda-nvrtc-${CUDA/./-} libcufft-${CUDA/./-} libcurand-${CUDA/./-} libcusolver-${CUDA/./-} libcusparse-${CUDA/./-} curl libcudnn8=${CUDNN}+cuda${CUDA} libfreetype6-dev libhdf5-serial-dev libzmq3-dev pkg-config software-properties-common unzip
|7 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 /bin/bash -c [[ "${ARCH}" = "ppc64le" ]] || { apt-get update  \
	&& apt-get install -y --no-install-recommends libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA}  \
	&& apt-get clean  \
	&& rm -rf /var/lib/apt/lists/*; }
/bin/bash -c #(nop) ENV LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64
|7 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 /bin/bash -c ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1  \
	&& echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf  \
	&& ldconfig
/bin/bash -c #(nop) ENV LANG=C.UTF-8
|7 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 /bin/bash -c apt-get update  \
	&& apt-get install -y python3 python3-pip
|7 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 /bin/bash -c python3 -m pip --no-cache-dir install --upgrade "pip<20.3" setuptools
|7 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 /bin/bash -c ln -s $(which python3) /usr/local/bin/python
/bin/bash -c #(nop) ARG TF_PACKAGE=tensorflow
/bin/bash -c #(nop) ARG TF_PACKAGE_VERSION=
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c python3 -m pip install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}
/bin/bash -c #(nop) COPY file:40186171ace294911872152eeeb8e478cf0693adf2319d231f3e46e8f863d8a9 in /etc/bash.bashrc
	etc/
	etc/bash.bashrc

|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c chmod a+rwx /etc/bash.bashrc
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c python3 -m pip install --no-cache-dir jupyter matplotlib
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c python3 -m pip install --no-cache-dir jupyter_http_over_ws ipykernel==5.1.1 nbformat==4.4.0
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c jupyter serverextension enable --py jupyter_http_over_ws
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c mkdir -p /tf/tensorflow-tutorials  \
	&& chmod -R a+rwx /tf/
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c mkdir /.local  \
	&& chmod a+rwx /.local
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c apt-get update  \
	&& apt-get install -y --no-install-recommends wget git
/bin/bash -c #(nop) WORKDIR /tf/tensorflow-tutorials
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/classification.ipynb
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/overfit_and_underfit.ipynb
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/regression.ipynb
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/save_and_load.ipynb
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/text_classification.ipynb
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c wget https://raw.githubusercontent.com/tensorflow/docs/master/site/en/tutorials/keras/text_classification_with_hub.ipynb
/bin/bash -c #(nop) COPY file:7bc7e4b8c1418d5388b95fe63c567bed20704a669789915d6a13f3c2fa5b9bf3 in README.md
	tf/
	tf/tensorflow-tutorials/
	tf/tensorflow-tutorials/README.md

|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c apt-get autoremove -y  \
	&& apt-get remove -y wget
/bin/bash -c #(nop) WORKDIR /tf
/bin/bash -c #(nop) EXPOSE 8888
|9 ARCH= CUDA=11.0 CUDNN=8.0.4.30-1 CUDNN_MAJOR_VERSION=8 LIBNVINFER=7.1.3-1 LIBNVINFER_MAJOR_VERSION=7 LIB_DIR_PREFIX=x86_64 TF_PACKAGE=tensorflow-gpu TF_PACKAGE_VERSION=2.4.0 /bin/bash -c python3 -m ipykernel.kernelspec
/bin/bash -c #(nop) CMD ["bash" "-c" "source /etc/bash.bashrc  \
	&& jupyter notebook --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root"]
bash
bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root

