from __future__ import annotations

import logging
from typing import Dict

import pytest
from _pytest.fixtures import FixtureRequest
from dbt_semantic_interfaces.naming.keywords import METRIC_TIME_ELEMENT_NAME
from metricflow_semantics.config_helpers import MetricFlowTestConfiguration
from metricflow_semantics.model.semantic_manifest_lookup import SemanticManifestLookup
from metricflow_semantics.naming.naming_scheme import QueryItemNamingScheme
from metricflow_semantics.naming.object_builder_scheme import ObjectBuilderNamingScheme
from metricflow_semantics.query.group_by_item.group_by_item_resolver import GroupByItemResolver
from metricflow_semantics.query.group_by_item.resolution_dag.dag import GroupByItemResolutionDag

from tests_metricflow.semantics.query.group_by_item.conftest import AmbiguousResolutionQueryId
from tests_metricflow.snapshot_utils import assert_object_snapshot_equal

logger = logging.getLogger(__name__)


@pytest.mark.parametrize("dag_case_id", [case_id.value for case_id in AmbiguousResolutionQueryId])
def test_ambiguous_metric_time_in_query_filter(  # noqa: D103
    request: FixtureRequest,
    mf_test_configuration: MetricFlowTestConfiguration,
    naming_scheme: QueryItemNamingScheme,
    ambiguous_resolution_manifest_lookup: SemanticManifestLookup,
    resolution_dags: Dict[AmbiguousResolutionQueryId, GroupByItemResolutionDag],
    dag_case_id: str,
) -> None:
    case_id = AmbiguousResolutionQueryId(dag_case_id)
    resolution_dag = resolution_dags[case_id]
    group_by_item_resolver = GroupByItemResolver(
        manifest_lookup=ambiguous_resolution_manifest_lookup,
        resolution_dag=resolution_dag,
    )

    input_str = f"TimeDimension('{METRIC_TIME_ELEMENT_NAME}')"
    spec_pattern = ObjectBuilderNamingScheme().spec_pattern(input_str)

    result = group_by_item_resolver.resolve_matching_item_for_filters(
        input_str=input_str,
        spec_pattern=spec_pattern,
        resolution_node=resolution_dag.sink_node,
    )

    assert_object_snapshot_equal(
        request=request,
        mf_test_configuration=mf_test_configuration,
        obj_id="result",
        obj=result,
    )
