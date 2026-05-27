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


EXPECTED_COLUMNS = ["prompt", "expectedWorkflow", "expectedDomainModule", "expectedMode"]

JAVA_SPRING_SIGNALS = [
    "java",
    "spring",
    "spring boot",
    "springboot",
    "springcloud",
    "spring cloud",
    "@restcontroller",
    "@service",
    "@transactional",
    "controller",
    "service",
    "mapper",
    "mybatis",
    "mybatis-plus",
    "mongo",
    "mongodb",
    "redis",
    "redisson",
    "rabbitmq",
    "kafka",
    "rocketmq",
    "mq",
    "feign",
    "openfeign",
    "nacos",
    "xxl-job",
    "spring security",
    "jwt",
    "gateway",
]

HIGH_RISK_SIGNALS = [
    "支付",
    "订单",
    "退款",
    "余额",
    "商户收益",
    "权限",
    "认证",
    "授权",
    "jwt",
    "patientid",
    "storeid",
    "tenantid",
    "deptid",
    "诊断报告",
    "健康计划",
    "医疗",
    "mq",
    "消费者",
    "消费逻辑",
    "重试",
    "死信",
    "dlq",
    "幂等",
    "数据迁移",
    "回填",
    "删除字段",
    "删除表",
    "破坏性",
    "跨服务",
    "共享表",
]


def validate_tsv_shape(path: Path) -> list[str]:
    errors: list[str] = []
    lines = path.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2:
        return [f"{path}: TSV must contain a header and at least one case row"]

    header = lines[0].split("\t")
    if header != EXPECTED_COLUMNS:
        errors.append(f"{path}: TSV header must be tab-delimited columns {EXPECTED_COLUMNS}, got {header}")

    for line_number, line in enumerate(lines[1:], start=2):
        columns = line.split("\t")
        if len(columns) != len(EXPECTED_COLUMNS):
            errors.append(
                f"{path}: line {line_number} must have {len(EXPECTED_COLUMNS)} tab-delimited columns, "
                f"got {len(columns)}"
            )
    return errors


def detect_domain_module(prompt: str) -> str:
    normalized = prompt.lower()
    if any(signal in normalized for signal in JAVA_SPRING_SIGNALS):
        return "java-spring-microservice"
    return "none"


def expected_mode(prompt: str, workflow: str, module: str) -> str:
    normalized = prompt.lower()
    if module == "java-spring-microservice" and (
        workflow in {"data-migration-planning"} or any(signal in normalized for signal in HIGH_RISK_SIGNALS)
    ):
        return "full"
    return "standard"


def main() -> int:
    parser = argparse.ArgumentParser(description="Check domain module routing fixture prompts.")
    parser.add_argument("--cases", default="tests/domain-modules/java-spring-microservice-cases.tsv")
    args = parser.parse_args()

    case_path = Path(args.cases)
    shape_errors = validate_tsv_shape(case_path)
    if shape_errors:
        for error in shape_errors:
            print(error, file=sys.stderr)
        return 1

    failed = False
    with case_path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for line_number, row in enumerate(reader, start=2):
            workflow, run = route(row["prompt"])
            module = detect_domain_module(row["prompt"])
            mode = expected_mode(row["prompt"], workflow, module) if run == "yes" else "none"
            expected = (row["expectedWorkflow"], row["expectedDomainModule"], row["expectedMode"])
            actual = (workflow, module, mode)
            if actual != expected:
                failed = True
                print(
                    f"FAIL line {line_number}:\n"
                    f"prompt={row['prompt']}\n"
                    f"expectedWorkflow={row['expectedWorkflow']} actualWorkflow={workflow}\n"
                    f"expectedDomainModule={row['expectedDomainModule']} actualDomainModule={module}\n"
                    f"expectedMode={row['expectedMode']} actualMode={mode}",
                    file=sys.stderr,
                )

    if failed:
        return 1
    print("Domain module routing checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
