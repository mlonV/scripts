route:
  group_by: ['alertname']
  group_wait: 1m
  group_interval: 3m
  repeat_interval: 1h
  receiver: 'devops'
receivers:
- name: 'devops'
  webhook_configs:
  - url: 'http://127.0.0.1:5000/sendmsg'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']