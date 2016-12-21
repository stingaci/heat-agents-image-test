Heat Agents Image Test
======================

In order to use `OS::Heat::SoftwareDeployments <http://docs.openstack.org/developer/heat/template_guide/openstack.html#OS::Heat::SoftwareDeployment>`_ the following agents are required on the image to be deployed:

* os-collect-config
* os-apply-config
* os-refresh-config 
* heat-engine 

This repo contains two templates that do the following:

no_agent_install.yaml 
---------------------

This template effectively tests weather or not these agents exist on the image. If they do, the stack creation should succeed with a status of CREATE_COMPLETE. If these agents don't exist on the image, then the stack creation will hang for a while in CREATE_IN_PROGRESS state and eventually move to a CREATE_FAILED status after a timeout period. This is due to the fact that SoftwareDeployments enables Heat to only mark the stack as "Complete" when the software configuration provided to the SoftwareDeployment resource definition has completed executing on the host. The agents will signal Heat (via `various signal transports <http://docs.openstack.org/developer/heat/template_guide/openstack.html#OS::Heat::SoftwareDeployment-prop-signal_transport>`_) to indicate completion, hence the reason the stack status will hang in CREATE_IN_PROGRESS. 

You can create a stack with this template as follows:

.. code-block:: bash

  os stack create -t no_agent_install.yaml \
    --parameter image="Centos 7" \
    --parameter network_name=my_net \
    --parameter security_group=my_sg \
    --parameter ssh_key=my_key \
    no_agent_install

with_agent_install.yaml
-----------------------

This template leverages cloud-init in order to install these agents and upon a successful installation, the agents will pull the supplied configuration and apply it to the running instance. The stack creation should succeed with a status of CREATE_COMPLETE or fail as previously described. One can debug cloud-init in order to determine the possible reasons for failure and tweak the respective scripts in software-config in order to address for these failures. 

You can create a stack with this template as follows:

.. code-block:: bash

  os stack create -t with_agent_install.yaml \
    -e software-config/boot-config/centos7_rdo_env.yaml \
    --parameter image="Centos 7" \
    --parameter network_name=my_net \
    --parameter security_group=my_sg \
    --parameter ssh_key=my_key \
    with_agent_install

An important point to mention here is the choice in environment. The chosen environment **must** match the image you are using. In my case I used the *Centos 7* and thus I used the *centos7_rdo_env* environment. 
