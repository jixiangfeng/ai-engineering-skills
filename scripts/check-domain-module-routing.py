#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import importlib.util
import sys
from pathlib import Path

BOOTSTRAP_ROUTING = Path(__file__).with_name("check-bootstrap-routing.py")
spec = importlib.util.spec_from_file_location("check_bootstrap_routing", BOOTSTRAP_ROUTING)
if spec is None or spec.loader is None:
    raise RuntimeError(f"Cannot load {BOOTSTRAP_ROUTING}")
bootstrap_routing = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bootstrap_routing)
route = bootstrap_routing.route


JAVA_SIGNALS = [
    "Spring Boot",
    "SpringBoot",
    "@RestController",
    "@Service",
    "@Transactional",
    "Controller",
    "Feign",
    "OpenFeign",
    "MyBatis",
    "Mapper",
    "Mongo",
    "Redis",
    "Redisson",
    "RabbitMQ",
    "Kafka",
    "RocketMQ",
    "MQ",
    "Nacos",
    "XXL-JOB",
    "Spring Security",
]

HIGH_RISK_SIGNALS = ["MQ", "MyBatis", "数据迁移", "回填", "删除", "支付", "权限", "健康计划", "诊断报告"]


def detect_domain_module(prompt: str) -> str:
    if any(signal in prompt for signal in JAVA_SIGNALS):
        return "java-spring-microservice"
    return "none"


def expected_mode(prompt: str, workflow: str, module: str) -> str:
    if module == "java-spring-microservice" and (
        workflow in {"data-migration-planning"} or any(signal in prompt for signal in HIGH_RISK_SIGNALS)
    ):
        return "full"
    return "standard"


def main() -> int:
    parser = argparse.ArgumentParser(description="Check domain module routing fixture prompts.")
    parser.add_argument("--cases", default="tests/domain-modules/java-spring-microservice-cases.tsv")
    args = parser.parse_args()

    failed = False
    with Path(args.cases).open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            workflow, run = route(row["prompt"])
            module = detect_domain_module(row["prompt"])
            mode = expected_mode(row["prompt"], workflow, module) if run == "yes" else "none"
            expected = (row["expectedWorkflow"], row["expectedDomainModule"], row["expectedMode"])
            actual = (workflow, module, mode)
            if actual != expected:
                failed = True
                print(f"{row['prompt']}: expected {expected}, got {actual}", file=sys.stderr)

    if failed:
        return 1
    print("Domain module routing checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
