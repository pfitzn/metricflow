from __future__ import annotations

from dataclasses import dataclass

from metricflow_semantics.snapshot_helpers import SnapshotConfiguration


@dataclass(frozen=True)
class MetricFlowTestConfiguration(SnapshotConfiguration):
    """State that is shared between tests during a testing session."""

    sql_engine_url: str
    sql_engine_password: str
    # Where MF system tables should be stored.
    mf_system_schema: str
    # Where tables for test data sets should be stored.
    mf_source_schema: str

    # Whether to display the graph associated with a test session in a browser window.
    display_graphs: bool

    # The source schema contains tables that are used for running tests. If this is set, a source schema in the SQL
    # is created and persisted between runs. The source schema name includes a hash of the tables that should be in
    # the schema, so
    use_persistent_source_schema: bool
