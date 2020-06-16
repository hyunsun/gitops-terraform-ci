images:
  tags:
    edgeMonitoring: "${edge_mon_docker_reg}/edge-monitoring-server:${edge_mon_image_tag}"
    hss: "${omec_cp_docker_reg}/c3po-hss:${omec_cp_hss_image_tag}"
    mme: "${omec_cp_docker_reg}/openmme:${omec_cp_mme_image_tag}"
    spgwc: "${omec_cp_docker_reg}/ngic-cp:${omec_cp_spgwc_image_tag}"
  pullPolicy: "Always"

resources:
  enabled: false

cassandra:
  config:
    cluster_size: 1
    seed_size: 1

config:
  clusterDomain: "dev.central"
  mme:
    cfgFiles:
      config.json:
        mme:
          plmnlist:
            plmn1: "mcc=315,mnc=010"
  spgwc:
    cfgFiles:
      app_config.cfg: |
        [GLOBAL]
        NUM_DP_SELECTION_RULES = 1
        DNS_PRIMARY = 1.1.1.1
        DNS_SECONDARY = 8.8.8.8
        IPV4_MTU = 1450
        [DP_SELECTION_RULE_1]
        DPID = 1
        DPNAME = dp-dev
        MCC = 315
        MNC = 010
        TAC = 202
