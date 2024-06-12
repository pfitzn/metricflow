-- Compute Metrics via Expressions
SELECT
  CAST(subq_14.buys AS FLOAT64) / CAST(NULLIF(subq_14.visits, 0) AS FLOAT64) AS visit_buy_conversion_rate_7days
FROM (
  -- Combine Aggregated Outputs
  SELECT
    MAX(subq_3.visits) AS visits
    , MAX(subq_13.buys) AS buys
  FROM (
    -- Aggregate Measures
    SELECT
      SUM(subq_2.visits) AS visits
    FROM (
      -- Pass Only Elements: ['visits',]
      SELECT
        subq_1.visits
      FROM (
        -- Metric Time Dimension 'ds'
        SELECT
          subq_0.ds__day
          , subq_0.ds__week
          , subq_0.ds__month
          , subq_0.ds__quarter
          , subq_0.ds__year
          , subq_0.ds__extract_year
          , subq_0.ds__extract_quarter
          , subq_0.ds__extract_month
          , subq_0.ds__extract_day
          , subq_0.ds__extract_dow
          , subq_0.ds__extract_doy
          , subq_0.visit__ds__day
          , subq_0.visit__ds__week
          , subq_0.visit__ds__month
          , subq_0.visit__ds__quarter
          , subq_0.visit__ds__year
          , subq_0.visit__ds__extract_year
          , subq_0.visit__ds__extract_quarter
          , subq_0.visit__ds__extract_month
          , subq_0.visit__ds__extract_day
          , subq_0.visit__ds__extract_dow
          , subq_0.visit__ds__extract_doy
          , subq_0.ds__day AS metric_time__day
          , subq_0.ds__week AS metric_time__week
          , subq_0.ds__month AS metric_time__month
          , subq_0.ds__quarter AS metric_time__quarter
          , subq_0.ds__year AS metric_time__year
          , subq_0.ds__extract_year AS metric_time__extract_year
          , subq_0.ds__extract_quarter AS metric_time__extract_quarter
          , subq_0.ds__extract_month AS metric_time__extract_month
          , subq_0.ds__extract_day AS metric_time__extract_day
          , subq_0.ds__extract_dow AS metric_time__extract_dow
          , subq_0.ds__extract_doy AS metric_time__extract_doy
          , subq_0.user
          , subq_0.session
          , subq_0.visit__user
          , subq_0.visit__session
          , subq_0.referrer_id
          , subq_0.visit__referrer_id
          , subq_0.visits
          , subq_0.visitors
        FROM (
          -- Read Elements From Semantic Model 'visits_source'
          SELECT
            1 AS visits
            , visits_source_src_28000.user_id AS visitors
            , DATETIME_TRUNC(visits_source_src_28000.ds, day) AS ds__day
            , DATETIME_TRUNC(visits_source_src_28000.ds, isoweek) AS ds__week
            , DATETIME_TRUNC(visits_source_src_28000.ds, month) AS ds__month
            , DATETIME_TRUNC(visits_source_src_28000.ds, quarter) AS ds__quarter
            , DATETIME_TRUNC(visits_source_src_28000.ds, year) AS ds__year
            , EXTRACT(year FROM visits_source_src_28000.ds) AS ds__extract_year
            , EXTRACT(quarter FROM visits_source_src_28000.ds) AS ds__extract_quarter
            , EXTRACT(month FROM visits_source_src_28000.ds) AS ds__extract_month
            , EXTRACT(day FROM visits_source_src_28000.ds) AS ds__extract_day
            , IF(EXTRACT(dayofweek FROM visits_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM visits_source_src_28000.ds) - 1) AS ds__extract_dow
            , EXTRACT(dayofyear FROM visits_source_src_28000.ds) AS ds__extract_doy
            , visits_source_src_28000.referrer_id
            , DATETIME_TRUNC(visits_source_src_28000.ds, day) AS visit__ds__day
            , DATETIME_TRUNC(visits_source_src_28000.ds, isoweek) AS visit__ds__week
            , DATETIME_TRUNC(visits_source_src_28000.ds, month) AS visit__ds__month
            , DATETIME_TRUNC(visits_source_src_28000.ds, quarter) AS visit__ds__quarter
            , DATETIME_TRUNC(visits_source_src_28000.ds, year) AS visit__ds__year
            , EXTRACT(year FROM visits_source_src_28000.ds) AS visit__ds__extract_year
            , EXTRACT(quarter FROM visits_source_src_28000.ds) AS visit__ds__extract_quarter
            , EXTRACT(month FROM visits_source_src_28000.ds) AS visit__ds__extract_month
            , EXTRACT(day FROM visits_source_src_28000.ds) AS visit__ds__extract_day
            , IF(EXTRACT(dayofweek FROM visits_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM visits_source_src_28000.ds) - 1) AS visit__ds__extract_dow
            , EXTRACT(dayofyear FROM visits_source_src_28000.ds) AS visit__ds__extract_doy
            , visits_source_src_28000.referrer_id AS visit__referrer_id
            , visits_source_src_28000.user_id AS user
            , visits_source_src_28000.session_id AS session
            , visits_source_src_28000.user_id AS visit__user
            , visits_source_src_28000.session_id AS visit__session
          FROM ***************************.fct_visits visits_source_src_28000
        ) subq_0
      ) subq_1
    ) subq_2
  ) subq_3
  CROSS JOIN (
    -- Aggregate Measures
    SELECT
      SUM(subq_12.buys) AS buys
    FROM (
      -- Pass Only Elements: ['buys',]
      SELECT
        subq_11.buys
      FROM (
        -- Find conversions for user within the range of 7 day
        SELECT
          subq_10.ds__day
          , subq_10.user
          , subq_10.buys
          , subq_10.visits
        FROM (
          -- Dedupe the fanout with mf_internal_uuid in the conversion data set
          SELECT DISTINCT
            FIRST_VALUE(subq_6.visits) OVER (
              PARTITION BY
                subq_9.user
                , subq_9.ds__day
                , subq_9.mf_internal_uuid
              ORDER BY subq_6.ds__day DESC
              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS visits
            , FIRST_VALUE(subq_6.ds__day) OVER (
              PARTITION BY
                subq_9.user
                , subq_9.ds__day
                , subq_9.mf_internal_uuid
              ORDER BY subq_6.ds__day DESC
              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS ds__day
            , FIRST_VALUE(subq_6.user) OVER (
              PARTITION BY
                subq_9.user
                , subq_9.ds__day
                , subq_9.mf_internal_uuid
              ORDER BY subq_6.ds__day DESC
              ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS user
            , subq_9.mf_internal_uuid AS mf_internal_uuid
            , subq_9.buys AS buys
          FROM (
            -- Pass Only Elements: ['visits', 'ds__day', 'user']
            SELECT
              subq_5.ds__day
              , subq_5.user
              , subq_5.visits
            FROM (
              -- Metric Time Dimension 'ds'
              SELECT
                subq_4.ds__day
                , subq_4.ds__week
                , subq_4.ds__month
                , subq_4.ds__quarter
                , subq_4.ds__year
                , subq_4.ds__extract_year
                , subq_4.ds__extract_quarter
                , subq_4.ds__extract_month
                , subq_4.ds__extract_day
                , subq_4.ds__extract_dow
                , subq_4.ds__extract_doy
                , subq_4.visit__ds__day
                , subq_4.visit__ds__week
                , subq_4.visit__ds__month
                , subq_4.visit__ds__quarter
                , subq_4.visit__ds__year
                , subq_4.visit__ds__extract_year
                , subq_4.visit__ds__extract_quarter
                , subq_4.visit__ds__extract_month
                , subq_4.visit__ds__extract_day
                , subq_4.visit__ds__extract_dow
                , subq_4.visit__ds__extract_doy
                , subq_4.ds__day AS metric_time__day
                , subq_4.ds__week AS metric_time__week
                , subq_4.ds__month AS metric_time__month
                , subq_4.ds__quarter AS metric_time__quarter
                , subq_4.ds__year AS metric_time__year
                , subq_4.ds__extract_year AS metric_time__extract_year
                , subq_4.ds__extract_quarter AS metric_time__extract_quarter
                , subq_4.ds__extract_month AS metric_time__extract_month
                , subq_4.ds__extract_day AS metric_time__extract_day
                , subq_4.ds__extract_dow AS metric_time__extract_dow
                , subq_4.ds__extract_doy AS metric_time__extract_doy
                , subq_4.user
                , subq_4.session
                , subq_4.visit__user
                , subq_4.visit__session
                , subq_4.referrer_id
                , subq_4.visit__referrer_id
                , subq_4.visits
                , subq_4.visitors
              FROM (
                -- Read Elements From Semantic Model 'visits_source'
                SELECT
                  1 AS visits
                  , visits_source_src_28000.user_id AS visitors
                  , DATETIME_TRUNC(visits_source_src_28000.ds, day) AS ds__day
                  , DATETIME_TRUNC(visits_source_src_28000.ds, isoweek) AS ds__week
                  , DATETIME_TRUNC(visits_source_src_28000.ds, month) AS ds__month
                  , DATETIME_TRUNC(visits_source_src_28000.ds, quarter) AS ds__quarter
                  , DATETIME_TRUNC(visits_source_src_28000.ds, year) AS ds__year
                  , EXTRACT(year FROM visits_source_src_28000.ds) AS ds__extract_year
                  , EXTRACT(quarter FROM visits_source_src_28000.ds) AS ds__extract_quarter
                  , EXTRACT(month FROM visits_source_src_28000.ds) AS ds__extract_month
                  , EXTRACT(day FROM visits_source_src_28000.ds) AS ds__extract_day
                  , IF(EXTRACT(dayofweek FROM visits_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM visits_source_src_28000.ds) - 1) AS ds__extract_dow
                  , EXTRACT(dayofyear FROM visits_source_src_28000.ds) AS ds__extract_doy
                  , visits_source_src_28000.referrer_id
                  , DATETIME_TRUNC(visits_source_src_28000.ds, day) AS visit__ds__day
                  , DATETIME_TRUNC(visits_source_src_28000.ds, isoweek) AS visit__ds__week
                  , DATETIME_TRUNC(visits_source_src_28000.ds, month) AS visit__ds__month
                  , DATETIME_TRUNC(visits_source_src_28000.ds, quarter) AS visit__ds__quarter
                  , DATETIME_TRUNC(visits_source_src_28000.ds, year) AS visit__ds__year
                  , EXTRACT(year FROM visits_source_src_28000.ds) AS visit__ds__extract_year
                  , EXTRACT(quarter FROM visits_source_src_28000.ds) AS visit__ds__extract_quarter
                  , EXTRACT(month FROM visits_source_src_28000.ds) AS visit__ds__extract_month
                  , EXTRACT(day FROM visits_source_src_28000.ds) AS visit__ds__extract_day
                  , IF(EXTRACT(dayofweek FROM visits_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM visits_source_src_28000.ds) - 1) AS visit__ds__extract_dow
                  , EXTRACT(dayofyear FROM visits_source_src_28000.ds) AS visit__ds__extract_doy
                  , visits_source_src_28000.referrer_id AS visit__referrer_id
                  , visits_source_src_28000.user_id AS user
                  , visits_source_src_28000.session_id AS session
                  , visits_source_src_28000.user_id AS visit__user
                  , visits_source_src_28000.session_id AS visit__session
                FROM ***************************.fct_visits visits_source_src_28000
              ) subq_4
            ) subq_5
          ) subq_6
          INNER JOIN (
            -- Add column with generated UUID
            SELECT
              subq_8.ds__day
              , subq_8.ds__week
              , subq_8.ds__month
              , subq_8.ds__quarter
              , subq_8.ds__year
              , subq_8.ds__extract_year
              , subq_8.ds__extract_quarter
              , subq_8.ds__extract_month
              , subq_8.ds__extract_day
              , subq_8.ds__extract_dow
              , subq_8.ds__extract_doy
              , subq_8.buy__ds__day
              , subq_8.buy__ds__week
              , subq_8.buy__ds__month
              , subq_8.buy__ds__quarter
              , subq_8.buy__ds__year
              , subq_8.buy__ds__extract_year
              , subq_8.buy__ds__extract_quarter
              , subq_8.buy__ds__extract_month
              , subq_8.buy__ds__extract_day
              , subq_8.buy__ds__extract_dow
              , subq_8.buy__ds__extract_doy
              , subq_8.metric_time__day
              , subq_8.metric_time__week
              , subq_8.metric_time__month
              , subq_8.metric_time__quarter
              , subq_8.metric_time__year
              , subq_8.metric_time__extract_year
              , subq_8.metric_time__extract_quarter
              , subq_8.metric_time__extract_month
              , subq_8.metric_time__extract_day
              , subq_8.metric_time__extract_dow
              , subq_8.metric_time__extract_doy
              , subq_8.user
              , subq_8.session_id
              , subq_8.buy__user
              , subq_8.buy__session_id
              , subq_8.buys
              , subq_8.buyers
              , GENERATE_UUID() AS mf_internal_uuid
            FROM (
              -- Metric Time Dimension 'ds'
              SELECT
                subq_7.ds__day
                , subq_7.ds__week
                , subq_7.ds__month
                , subq_7.ds__quarter
                , subq_7.ds__year
                , subq_7.ds__extract_year
                , subq_7.ds__extract_quarter
                , subq_7.ds__extract_month
                , subq_7.ds__extract_day
                , subq_7.ds__extract_dow
                , subq_7.ds__extract_doy
                , subq_7.buy__ds__day
                , subq_7.buy__ds__week
                , subq_7.buy__ds__month
                , subq_7.buy__ds__quarter
                , subq_7.buy__ds__year
                , subq_7.buy__ds__extract_year
                , subq_7.buy__ds__extract_quarter
                , subq_7.buy__ds__extract_month
                , subq_7.buy__ds__extract_day
                , subq_7.buy__ds__extract_dow
                , subq_7.buy__ds__extract_doy
                , subq_7.ds__day AS metric_time__day
                , subq_7.ds__week AS metric_time__week
                , subq_7.ds__month AS metric_time__month
                , subq_7.ds__quarter AS metric_time__quarter
                , subq_7.ds__year AS metric_time__year
                , subq_7.ds__extract_year AS metric_time__extract_year
                , subq_7.ds__extract_quarter AS metric_time__extract_quarter
                , subq_7.ds__extract_month AS metric_time__extract_month
                , subq_7.ds__extract_day AS metric_time__extract_day
                , subq_7.ds__extract_dow AS metric_time__extract_dow
                , subq_7.ds__extract_doy AS metric_time__extract_doy
                , subq_7.user
                , subq_7.session_id
                , subq_7.buy__user
                , subq_7.buy__session_id
                , subq_7.buys
                , subq_7.buyers
              FROM (
                -- Read Elements From Semantic Model 'buys_source'
                SELECT
                  1 AS buys
                  , buys_source_src_28000.user_id AS buyers
                  , DATETIME_TRUNC(buys_source_src_28000.ds, day) AS ds__day
                  , DATETIME_TRUNC(buys_source_src_28000.ds, isoweek) AS ds__week
                  , DATETIME_TRUNC(buys_source_src_28000.ds, month) AS ds__month
                  , DATETIME_TRUNC(buys_source_src_28000.ds, quarter) AS ds__quarter
                  , DATETIME_TRUNC(buys_source_src_28000.ds, year) AS ds__year
                  , EXTRACT(year FROM buys_source_src_28000.ds) AS ds__extract_year
                  , EXTRACT(quarter FROM buys_source_src_28000.ds) AS ds__extract_quarter
                  , EXTRACT(month FROM buys_source_src_28000.ds) AS ds__extract_month
                  , EXTRACT(day FROM buys_source_src_28000.ds) AS ds__extract_day
                  , IF(EXTRACT(dayofweek FROM buys_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM buys_source_src_28000.ds) - 1) AS ds__extract_dow
                  , EXTRACT(dayofyear FROM buys_source_src_28000.ds) AS ds__extract_doy
                  , DATETIME_TRUNC(buys_source_src_28000.ds, day) AS buy__ds__day
                  , DATETIME_TRUNC(buys_source_src_28000.ds, isoweek) AS buy__ds__week
                  , DATETIME_TRUNC(buys_source_src_28000.ds, month) AS buy__ds__month
                  , DATETIME_TRUNC(buys_source_src_28000.ds, quarter) AS buy__ds__quarter
                  , DATETIME_TRUNC(buys_source_src_28000.ds, year) AS buy__ds__year
                  , EXTRACT(year FROM buys_source_src_28000.ds) AS buy__ds__extract_year
                  , EXTRACT(quarter FROM buys_source_src_28000.ds) AS buy__ds__extract_quarter
                  , EXTRACT(month FROM buys_source_src_28000.ds) AS buy__ds__extract_month
                  , EXTRACT(day FROM buys_source_src_28000.ds) AS buy__ds__extract_day
                  , IF(EXTRACT(dayofweek FROM buys_source_src_28000.ds) = 1, 7, EXTRACT(dayofweek FROM buys_source_src_28000.ds) - 1) AS buy__ds__extract_dow
                  , EXTRACT(dayofyear FROM buys_source_src_28000.ds) AS buy__ds__extract_doy
                  , buys_source_src_28000.user_id AS user
                  , buys_source_src_28000.session_id
                  , buys_source_src_28000.user_id AS buy__user
                  , buys_source_src_28000.session_id AS buy__session_id
                FROM ***************************.fct_buys buys_source_src_28000
              ) subq_7
            ) subq_8
          ) subq_9
          ON
            (
              subq_6.user = subq_9.user
            ) AND (
              (
                subq_6.ds__day <= subq_9.ds__day
              ) AND (
                subq_6.ds__day > DATE_SUB(CAST(subq_9.ds__day AS DATETIME), INTERVAL 7 day)
              )
            )
        ) subq_10
      ) subq_11
    ) subq_12
  ) subq_13
) subq_14
