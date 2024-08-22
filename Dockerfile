# Redhat Container Images: https://catalog.redhat.com/software/containers/search (only use images from RH)
FROM registry.access.redhat.com/ubi9/httpd-24:1-331.1724037694

USER root

# CVE-2022-40897⁠ Remove setuptools
# OS update and install nec packages
# Cleanup
# Running as one "RUN" reduces layers and saves some space in the resulting image
RUN dnf remove setuptools && dnf update -y && dnf install mod_security_crs mod_security-mlogc -y &&  \
    dnf clean all && rm -rf /var/cache/yum

# CVE-2022-40897. This module is in the base RHEL UBI.
RUN dnf remove python-setuptools -y

WORKDIR /etc/httpd/conf.d
RUN rm userdir.conf welcome.conf autoindex.conf 


COPY ./httpd/conf /etc/httpd/conf
COPY ./httpd/conf.d /etc/httpd/conf.d
COPY ./www/html /var/www/html


#EXPOSE 80
#EXPOSE 443