OPSWORKS()                                                          OPSWORKS()



NNAAMMEE
       opsworks -

DDEESSCCRRIIPPTTIIOONN
       Welcome  to the _A_W_S _O_p_s_W_o_r_k_s _S_t_a_c_k_s _A_P_I _R_e_f_e_r_e_n_c_e . This guide provides
       descriptions, syntax,  and  usage  examples  for  AWS  OpsWorks  Stacks
       actions and data types, including common parameters and error codes.

       AWS  OpsWorks Stacks is an application management service that provides
       an integrated experience for overseeing the complete application  life-
       cycle.  For  information  about  this  product,  go to the _A_W_S _O_p_s_W_o_r_k_s
       details page.
          SSDDKKss aanndd CCLLII

       The most common way to use the AWS OpsWorks Stacks API is by using  the
       AWS  Command  Line  Interface  (CLI) or by using one of the AWS SDKs to
       implement applications in your preferred language.  For  more  informa-
       tion, see:

       +o _A_W_S _C_L_I

       +o _A_W_S _S_D_K _f_o_r _J_a_v_a

       +o _A_W_S _S_D_K _f_o_r _._N_E_T

       +o _A_W_S _S_D_K _f_o_r _P_H_P _2

       +o _A_W_S _S_D_K _f_o_r _R_u_b_y

       +o _A_W_S _S_D_K _f_o_r _N_o_d_e_._j_s

       +o _A_W_S _S_D_K _f_o_r _P_y_t_h_o_n_(_B_o_t_o_)
          EEnnddppooiinnttss

       AWS  OpsWorks  Stacks  supports the following endpoints, all HTTPS. You
       must connect to one of the following  endpoints.  Stacks  can  only  be
       accessed or managed within the endpoint in which they are created.

       +o opsworks.us-east-1.amazonaws.com

       +o opsworks.us-east-2.amazonaws.com

       +o opsworks.us-west-1.amazonaws.com

       +o opsworks.us-west-2.amazonaws.com

       +o opsworks.ca-central-1.amazonaws.com  (API  only; not available in the
         AWS console)

       +o opsworks.eu-west-1.amazonaws.com

       +o opsworks.eu-west-2.amazonaws.com

       +o opsworks.eu-west-3.amazonaws.com

       +o opsworks.eu-central-1.amazonaws.com

       +o opsworks.ap-northeast-1.amazonaws.com

       +o opsworks.ap-northeast-2.amazonaws.com

       +o opsworks.ap-south-1.amazonaws.com

       +o opsworks.ap-southeast-1.amazonaws.com

       +o opsworks.ap-southeast-2.amazonaws.com

       +o opsworks.sa-east-1.amazonaws.com
          CChheeff VVeerrssiioonnss

       When you call  create-stack ,  clone-stack , or  update-stack we recom-
       mend  you  use  the  CCoonnffiigguurraattiioonnMMaannaaggeerr parameter to specify the Chef
       version. The recommended and default value for  Linux  stacks  is  cur-
       rently 12. Windows stacks use Chef 12.2. For more information, see _C_h_e_f
       _V_e_r_s_i_o_n_s .

       NNOOTTEE::
          You can specify Chef 12, 11.10, or 11.4 for  your  Linux  stack.  We
          recommend migrating your existing Linux stacks to Chef 12 as soon as
          possible.

AAVVAAIILLAABBLLEE CCOOMMMMAANNDDSS
       +o assign-instance

       +o assign-volume

       +o associate-elastic-ip

       +o attach-elastic-load-balancer

       +o clone-stack

       +o create-app

       +o create-deployment

       +o create-instance

       +o create-layer

       +o create-stack

       +o create-user-profile

       +o delete-app

       +o delete-instance

       +o delete-layer

       +o delete-stack

       +o delete-user-profile

       +o deregister-ecs-cluster

       +o deregister-elastic-ip

       +o deregister-instance

       +o deregister-rds-db-instance

       +o deregister-volume

       +o describe-agent-versions

       +o describe-apps

       +o describe-commands

       +o describe-deployments

       +o describe-ecs-clusters

       +o describe-elastic-ips

       +o describe-elastic-load-balancers

       +o describe-instances

       +o describe-layers

       +o describe-load-based-auto-scaling

       +o describe-my-user-profile

       +o describe-operating-systems

       +o describe-permissions

       +o describe-raid-arrays

       +o describe-rds-db-instances

       +o describe-service-errors

       +o describe-stack-provisioning-parameters

       +o describe-stack-summary

       +o describe-stacks

       +o describe-time-based-auto-scaling

       +o describe-user-profiles

       +o describe-volumes

       +o detach-elastic-load-balancer

       +o disassociate-elastic-ip

       +o get-hostname-suggestion

       +o grant-access

       +o help

       +o list-tags

       +o reboot-instance

       +o register

       +o register-ecs-cluster

       +o register-elastic-ip

       +o register-instance

       +o register-rds-db-instance

       +o register-volume

       +o set-load-based-auto-scaling

       +o set-permission

       +o set-time-based-auto-scaling

       +o start-instance

       +o start-stack

       +o stop-instance

       +o stop-stack

       +o tag-resource

       +o unassign-instance

       +o unassign-volume

       +o untag-resource

       +o update-app

       +o update-elastic-ip

       +o update-instance

       +o update-layer

       +o update-my-user-profile

       +o update-rds-db-instance

       +o update-stack

       +o update-user-profile

       +o update-volume

       +o wait



                                                                    OPSWORKS()
