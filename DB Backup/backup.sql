--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF EXISTS (
      SELECT 1
      FROM pg_event_trigger_ddl_commands() AS ev
      JOIN pg_extension AS ext
      ON ev.objid = ext.oid
      WHERE ext.extname = 'pg_net'
    )
    THEN
      GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END;
  $$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: delete_non_sos_notifications(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_non_sos_notifications() RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
  DELETE FROM inapp_notifications
  WHERE notification_type_id != (
    SELECT notification_type_id
    FROM notification_types
    WHERE notification_name = 'SOS Alerts'
  );
END;$$;


ALTER FUNCTION public.delete_non_sos_notifications() OWNER TO postgres;

--
-- Name: populate_user_preferences(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.populate_user_preferences() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  INSERT INTO user_notification_preferences ("userID", notification_type_id, service_id, is_enabled)
  SELECT
      NEW."userID",
      nt.notification_type_id,
      ms.service_id,
      TRUE -- Default value for is_enabled
  FROM notification_types nt, message_services ms;

  RETURN NEW;
END;$$;


ALTER FUNCTION public.populate_user_preferences() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
    DECLARE
      request_id bigint;
      payload jsonb;
      url text := TG_ARGV[0]::text;
      method text := TG_ARGV[1]::text;
      headers jsonb DEFAULT '{}'::jsonb;
      params jsonb DEFAULT '{}'::jsonb;
      timeout_ms integer DEFAULT 1000;
    BEGIN
      IF url IS NULL OR url = 'null' THEN
        RAISE EXCEPTION 'url argument is missing';
      END IF;

      IF method IS NULL OR method = 'null' THEN
        RAISE EXCEPTION 'method argument is missing';
      END IF;

      IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
        headers = '{"Content-Type": "application/json"}'::jsonb;
      ELSE
        headers = TG_ARGV[2]::jsonb;
      END IF;

      IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
        params = '{}'::jsonb;
      ELSE
        params = TG_ARGV[3]::jsonb;
      END IF;

      IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
        timeout_ms = 1000;
      ELSE
        timeout_ms = TG_ARGV[4]::integer;
      END IF;

      CASE
        WHEN method = 'GET' THEN
          SELECT http_get INTO request_id FROM net.http_get(
            url,
            params,
            headers,
            timeout_ms
          );
        WHEN method = 'POST' THEN
          payload = jsonb_build_object(
            'old_record', OLD,
            'record', NEW,
            'type', TG_OP,
            'table', TG_TABLE_NAME,
            'schema', TG_TABLE_SCHEMA
          );

          SELECT http_post INTO request_id FROM net.http_post(
            url,
            payload,
            params,
            headers,
            timeout_ms
          );
        ELSE
          RAISE EXCEPTION 'method argument % is invalid', method;
      END CASE;

      INSERT INTO supabase_functions.hooks
        (hook_table_id, hook_name, request_id)
      VALUES
        (TG_RELID, TG_NAME, request_id);

      RETURN NEW;
    END
  $$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: api_service_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_service_config (
    service_name text NOT NULL,
    base_url text NOT NULL
);


ALTER TABLE public.api_service_config OWNER TO postgres;

--
-- Name: button_user_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.button_user_config (
    button_mac text NOT NULL,
    "userID" bigint NOT NULL
);


ALTER TABLE public.button_user_config OWNER TO postgres;

--
-- Name: current_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_location (
    "userID" bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric,
    "timestamp" timestamp without time zone,
    police_region_id text
);


ALTER TABLE public.current_location OWNER TO postgres;

--
-- Name: current_location_userID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.current_location ALTER COLUMN "userID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."current_location_userID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: friend_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.friend_relations (
    "userID" bigint NOT NULL,
    "friendID" bigint NOT NULL
);


ALTER TABLE public.friend_relations OWNER TO postgres;

--
-- Name: friend_relations_userID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.friend_relations ALTER COLUMN "userID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."friend_relations_userID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inapp_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inapp_notifications (
    notification_id bigint NOT NULL,
    notifier_id bigint,
    notification_type_id bigint,
    message text,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inapp_notifications OWNER TO postgres;

--
-- Name: TABLE inapp_notifications; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.inapp_notifications IS 'This table container the inapp notifications';


--
-- Name: inapp_notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.inapp_notifications ALTER COLUMN notification_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inapp_notifications_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: incident_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_reports (
    id bigint NOT NULL,
    "userID" bigint NOT NULL,
    "typeID" bigint,
    "subtypeID" bigint,
    description text,
    latitude numeric,
    longitude numeric,
    place_name text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.incident_reports OWNER TO postgres;

--
-- Name: TABLE incident_reports; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.incident_reports IS 'The incident reported by various users';


--
-- Name: incident_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.incident_reports ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.incident_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: incident_sub_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_sub_types (
    "subtypeID" bigint NOT NULL,
    "typeID" bigint NOT NULL,
    sub_type text
);


ALTER TABLE public.incident_sub_types OWNER TO postgres;

--
-- Name: TABLE incident_sub_types; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.incident_sub_types IS 'This is a duplicate of incident_types';


--
-- Name: incident_sub_types_typeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.incident_sub_types ALTER COLUMN "subtypeID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."incident_sub_types_typeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: incident_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_types (
    "typeID" bigint NOT NULL,
    type text NOT NULL
);


ALTER TABLE public.incident_types OWNER TO postgres;

--
-- Name: TABLE incident_types; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.incident_types IS 'Includes main type of incidents that can Occur';


--
-- Name: incident_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.incident_types ALTER COLUMN "typeID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.incident_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: message_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_services (
    service_id bigint NOT NULL,
    service_name text NOT NULL
);


ALTER TABLE public.message_services OWNER TO postgres;

--
-- Name: TABLE message_services; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.message_services IS 'This table contains the messaging services provided by our application';


--
-- Name: message_services_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.message_services ALTER COLUMN service_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.message_services_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notification_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_types (
    notification_type_id bigint NOT NULL,
    notification_name text NOT NULL
);


ALTER TABLE public.notification_types OWNER TO postgres;

--
-- Name: TABLE notification_types; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.notification_types IS 'This table stores the types of notifications in our application';


--
-- Name: notification_types_notification_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.notification_types ALTER COLUMN notification_type_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.notification_types_notification_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pending_friend_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pending_friend_relations (
    "senderID" bigint NOT NULL,
    "receiverID" bigint NOT NULL
);


ALTER TABLE public.pending_friend_relations OWNER TO postgres;

--
-- Name: pending_friend_relations_senderID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pending_friend_relations ALTER COLUMN "senderID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."pending_friend_relations_senderID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: poker_user_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poker_user_requests (
    sender_poker_id bigint NOT NULL,
    receiver_poker_id bigint NOT NULL,
    acknowledgement_status boolean
);


ALTER TABLE public.poker_user_requests OWNER TO postgres;

--
-- Name: TABLE poker_user_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.poker_user_requests IS 'Storing poke requests for user';


--
-- Name: poke_user_requests_sender_poker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.poker_user_requests ALTER COLUMN sender_poker_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.poke_user_requests_sender_poker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: travel_locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_locations (
    "userID" bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric,
    location_name text,
    location_id bigint NOT NULL,
    place_nick_name text NOT NULL
);


ALTER TABLE public.travel_locations OWNER TO postgres;

--
-- Name: TABLE travel_locations; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.travel_locations IS 'Table to store safe locations of users';


--
-- Name: travel_locations__userID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.travel_locations ALTER COLUMN "userID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."travel_locations__userID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: travel_locations_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.travel_locations ALTER COLUMN location_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.travel_locations_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: travel_mode_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.travel_mode_details (
    "userID" bigint NOT NULL,
    source_latitude numeric NOT NULL,
    source_longitude numeric,
    destination_latitude numeric,
    destination_longitude numeric,
    notification_frequency bigint,
    last_notification_timestamp timestamp without time zone DEFAULT now(),
    "isValid" boolean
);


ALTER TABLE public.travel_mode_details OWNER TO postgres;

--
-- Name: TABLE travel_mode_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.travel_mode_details IS 'The travel details of user moving';


--
-- Name: travel_mode_details_userID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.travel_mode_details ALTER COLUMN "userID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."travel_mode_details_userID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_notification_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_notification_preferences (
    "userID" bigint NOT NULL,
    notification_type_id bigint NOT NULL,
    service_id bigint NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.user_notification_preferences OWNER TO postgres;

--
-- Name: TABLE user_notification_preferences; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_notification_preferences IS 'This table contains the preferences of user notifications';


--
-- Name: user_notification_preferences_userID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.user_notification_preferences ALTER COLUMN "userID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."user_notification_preferences_userID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    "userID" bigint NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    phone_no text NOT NULL,
    aadhar_no text NOT NULL,
    profile_pic_location text,
    aadhar_location text,
    public_key text NOT NULL,
    private_key text NOT NULL,
    device_token text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: COLUMN users.device_token; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.device_token IS 'FCM Device Token';


--
-- Name: users_userID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN "userID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."users_userID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: verification_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_codes (
    email text NOT NULL,
    code text NOT NULL,
    expiry timestamp without time zone
);


ALTER TABLE public.verification_codes OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: supabase_admin
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER VIEW vault.decrypted_secrets OWNER TO supabase_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: cron; Owner: supabase_admin
--

COPY cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) FROM stdin;
1	0 0 * * *	SELECT public.delete_non_sos_notifications()	localhost	5432	postgres	postgres	t	delete_inapp_notifications_cron_job
\.


--
-- Data for Name: job_run_details; Type: TABLE DATA; Schema: cron; Owner: supabase_admin
--

COPY cron.job_run_details (jobid, runid, job_pid, database, username, command, status, return_message, start_time, end_time) FROM stdin;
1	1	165579	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-01-29 00:00:00.429816+00	2025-01-29 00:00:00.433208+00
1	12	398478	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-09 00:00:00.341488+00	2025-02-09 00:00:00.373622+00
1	2	186521	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-01-30 00:00:00.370487+00	2025-01-30 00:00:00.375854+00
1	3	207426	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-01-31 00:00:00.391235+00	2025-01-31 00:00:00.398961+00
1	13	419800	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-10 00:00:00.352511+00	2025-02-10 00:00:00.412422+00
1	4	227238	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-01 00:00:00.40281+00	2025-02-01 00:00:00.452228+00
1	14	439000	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-11 00:00:00.308277+00	2025-02-11 00:00:00.323362+00
1	5	246282	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-02 00:00:00.321364+00	2025-02-02 00:00:00.349194+00
1	6	265416	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-03 00:00:00.46737+00	2025-02-03 00:00:00.48821+00
1	15	458504	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-12 00:00:00.542742+00	2025-02-12 00:00:00.603232+00
1	7	284633	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-04 00:00:00.249227+00	2025-02-04 00:00:00.251497+00
1	8	305649	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-05 00:00:00.302016+00	2025-02-05 00:00:00.309108+00
1	16	477557	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-13 00:00:00.277563+00	2025-02-13 00:00:00.334493+00
1	9	328072	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-06 00:00:00.514407+00	2025-02-06 00:00:00.520573+00
1	10	349539	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-07 00:00:00.371174+00	2025-02-07 00:00:00.403303+00
1	11	373378	postgres	postgres	SELECT public.delete_non_sos_notifications()	succeeded	1 row	2025-02-08 00:00:00.38359+00	2025-02-08 00:00:00.411887+00
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: api_service_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_service_config (service_name, base_url) FROM stdin;
auth_service	http://143.110.183.53/auth-service/auth/
travel_alert_service	http://192.168.1.89:8000/
incident_reporting_service	http://192.168.1.89:8001/
sos_reporting_service	http://192.168.1.89:8004/
chatbot_service	http://192.168.1.89:8003/
notification_service	http://143.110.183.53/notification-service
\.


--
-- Data for Name: button_user_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.button_user_config (button_mac, "userID") FROM stdin;
41b147ca-6d75-4617-8c2a-1e86c3d88723	43
\.


--
-- Data for Name: current_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.current_location ("userID", latitude, longitude, "timestamp", police_region_id) FROM stdin;
48	18.4575374	73.8507201	2025-02-09 13:59:58.543683	6799c9845c95f58e3275961e
43	18.4613894	73.8636977	2025-02-09 21:14:52.749524	6799c9845c95f58e3275961e
45	18.4575042	73.8506351	2025-02-11 10:20:32.868911	6799c9845c95f58e3275961e
47	18.4576548	73.8511313	2025-02-09 03:31:37.048377	6799c9845c95f58e3275961e
\.


--
-- Data for Name: friend_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.friend_relations ("userID", "friendID") FROM stdin;
45	43
43	45
47	43
43	47
48	43
43	48
\.


--
-- Data for Name: inapp_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inapp_notifications (notification_id, notifier_id, notification_type_id, message, is_read, created_at) FROM stdin;
1563	43	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:07:32.026662+00
1564	45	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:07:35.646706+00
1567	43	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:08:56.560682+00
1571	43	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:09:33.950262+00
1587	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:17.533785+00
1590	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:32.213028+00
1593	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:46.044052+00
1599	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:22:13.726863+00
1609	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:23:34.51187+00
1619	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:46:36.696406+00
1623	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:47:09.676594+00
1624	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:47:13.858821+00
1628	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:48:42.138525+00
1631	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:05.866517+00
1633	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:15.382181+00
1636	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:29.144285+00
1639	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:41.93227+00
1640	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:46.066539+00
1641	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:50.398092+00
1645	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:08.71979+00
1649	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:25.977857+00
1651	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:34.319148+00
1653	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:43.575018+00
1655	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:51.894449+00
1656	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:56.034514+00
1660	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:13.787175+00
1661	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:19.267234+00
1665	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:36.471396+00
1667	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:45.070362+00
1668	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:49.168652+00
1671	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:01.765641+00
1672	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:05.909143+00
1673	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:10.093997+00
1675	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:18.37405+00
1684	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:58.159373+00
1687	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:12.785787+00
1693	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:39.625828+00
1695	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:47.946724+00
1704	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:55:35.261256+00
1709	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:55:56.021756+00
1713	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:57:36.583934+00
1714	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:57:41.462527+00
1716	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:57:49.8965+00
1718	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:57:58.329564+00
1568	45	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:09:00.075128+00
1572	45	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:09:37.37881+00
1585	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:08.842817+00
1591	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:37.666317+00
1594	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:51.280738+00
1597	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:22:04.076345+00
1603	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:22:31.938462+00
1605	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:23:17.525388+00
1611	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:23:43.175178+00
1620	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:46:40.852232+00
1625	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:47:18.231072+00
1629	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:48:46.619678+00
1637	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:33.56273+00
1643	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:59.820677+00
1644	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:04.291161+00
1648	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:21.656526+00
1657	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:00.426179+00
1663	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:27.821781+00
1676	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:22.496404+00
1679	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:35.258067+00
1683	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:53.229525+00
1685	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:02.395552+00
1697	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:56.288238+00
1705	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:55:39.465186+00
1708	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:55:51.782806+00
1712	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:57:32.548922+00
1717	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:57:53.970993+00
1720	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:59:34.074632+00
1722	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:59:42.416857+00
1725	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:59:55.268742+00
1732	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:10:59.069154+00
1733	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:11:04.227838+00
1734	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:11:08.597579+00
1740	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:16:09.132124+00
1741	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:16:13.357186+00
1742	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:16:17.697772+00
1744	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:16:36.336867+00
1745	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:16:40.528307+00
1746	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:16:44.883707+00
1748	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:18:12.011282+00
1566	47	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:07:42.658986+00
1570	47	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:09:07.106728+00
1574	47	0	🚨 Amey sent an SOS! Check location & contact for safety 📍	f	2025-02-09 04:09:44.305471+00
1586	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:13.166953+00
1589	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:27.973205+00
1595	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:21:55.607151+00
1598	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:22:08.371688+00
1601	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:22:22.184552+00
1602	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:22:26.495711+00
1606	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:23:21.724248+00
1607	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:23:26.123745+00
1610	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:23:38.781493+00
1621	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:46:45.257493+00
1627	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:48:37.987584+00
1632	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:10.111372+00
1635	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:49:23.876172+00
1647	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:17.53225+00
1652	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:50:38.675295+00
1659	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:09.562058+00
1664	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:32.06549+00
1669	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:51:53.38616+00
1677	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:26.888092+00
1680	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:39.362335+00
1681	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:52:43.626811+00
1688	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:16.82522+00
1689	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:21.192008+00
1691	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:29.468734+00
1692	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:35.335446+00
1696	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:53:52.015836+00
1699	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:54:04.695102+00
1700	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:54:08.829422+00
1701	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:54:13.043389+00
1703	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:55:31.16071+00
1707	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:55:47.693948+00
1721	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:59:38.150112+00
1724	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:59:50.569537+00
1726	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 06:59:59.534744+00
1728	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:08:56.90193+00
1729	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:09:01.159178+00
1730	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:09:06.531586+00
1736	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:14:08.717056+00
1737	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:14:13.0117+00
1738	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:14:17.399593+00
1749	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:18:16.221964+00
1750	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:18:20.735852+00
1756	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:20:12.824104+00
1762	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:20:47.982449+00
1752	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:18:39.069885+00
1753	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:18:43.398934+00
1758	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:20:23.142716+00
1760	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:20:39.346194+00
1761	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:20:43.631362+00
1785	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:40:40.863844+00
1787	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:40:50.650831+00
1797	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:43:06.470076+00
1799	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:43:14.951126+00
1801	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:44:31.702239+00
1802	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:44:36.906119+00
1754	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:18:48.730463+00
1757	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:20:17.782605+00
1786	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:40:45.192626+00
1789	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:41:04.446758+00
1790	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:41:08.698664+00
1791	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:41:13.086324+00
1793	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:42:29.918564+00
1794	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:42:34.073298+00
1795	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:42:38.650584+00
1798	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:43:10.604719+00
1803	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:44:41.269274+00
1805	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:46:34.160034+00
1806	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:46:38.478209+00
1807	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:46:42.737069+00
1809	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:47:00.138023+00
1810	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:47:04.335511+00
1811	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:47:08.695611+00
1813	45	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:48:34.675034+00
1814	47	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:48:39.702539+00
1815	48	0	🚨 Advait sent an SOS! Check location & contact for safety 📍	f	2025-02-09 08:48:44.085382+00
\.


--
-- Data for Name: incident_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_reports (id, "userID", "typeID", "subtypeID", description, latitude, longitude, place_name, created_at) FROM stdin;
\.


--
-- Data for Name: incident_sub_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_sub_types ("subtypeID", "typeID", sub_type) FROM stdin;
1	1	Verbal Abuse
2	1	Sexual Harassment
3	1	Cyberbullying
4	1	Stalking
5	2	Physical Assault
6	2	Domestic Violence
7	2	Road Rage
8	2	Gang-Related Violence
9	2	Armed Robbery
10	3	Road Traffic Accident
11	3	Workplace Accident
12	3	Domestic Accident
13	3	Natural Disaster
14	3	Fire Accident
15	4	Robbery
16	4	Shoplifting
17	4	Cyber Theft
18	4	Burglary
19	4	Pickpocketing
\.


--
-- Data for Name: incident_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_types ("typeID", type) FROM stdin;
1	Harassment
2	Violence
4	Theft
3	Accident
\.


--
-- Data for Name: message_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_services (service_id, service_name) FROM stdin;
1	SMS
2	Email
3	InApp
4	Push Notifications
\.


--
-- Data for Name: notification_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_types (notification_type_id, notification_name) FROM stdin;
0	SOS Alerts
1	Adaptive Location Alerts
2	Travel Alerts
3	Generic Alerts
\.


--
-- Data for Name: pending_friend_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pending_friend_relations ("senderID", "receiverID") FROM stdin;
49	48
49	47
\.


--
-- Data for Name: poker_user_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poker_user_requests (sender_poker_id, receiver_poker_id, acknowledgement_status) FROM stdin;
48	43	t
45	43	t
43	47	t
43	45	t
\.


--
-- Data for Name: travel_locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.travel_locations ("userID", latitude, longitude, location_name, location_id, place_nick_name) FROM stdin;
43	18.5105764	73.8049956	Sajjangad Society	26	Home
45	18.5031888	73.8304485	Pinnacle Kalpataru	27	Home
43	18.4575421	73.8508336	SCTR'S Pune Institute of Computer Technology	28	College 
45	18.4575421	73.8508336	SCTR'S Pune Institute of Computer Technology	29	College
\.


--
-- Data for Name: travel_mode_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.travel_mode_details ("userID", source_latitude, source_longitude, destination_latitude, destination_longitude, notification_frequency, last_notification_timestamp, "isValid") FROM stdin;
43	18.6637505	73.7296521	18.5105764	73.8049956	5	2025-02-09 12:10:38.366121	f
\.


--
-- Data for Name: user_notification_preferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_notification_preferences ("userID", notification_type_id, service_id, is_enabled) FROM stdin;
43	0	1	t
43	0	2	t
43	0	3	t
43	0	4	t
43	1	1	t
43	1	2	t
43	1	3	t
43	1	4	t
43	2	1	t
43	2	2	t
43	2	3	t
43	2	4	t
43	3	1	t
43	3	2	t
43	3	3	t
43	3	4	t
45	0	1	t
45	0	2	t
45	0	3	t
45	0	4	t
45	1	1	t
45	1	2	t
45	1	3	t
45	1	4	t
45	2	1	t
45	2	2	t
45	2	3	t
45	2	4	t
45	3	1	t
45	3	2	t
45	3	3	t
45	3	4	t
47	0	1	t
47	0	2	t
47	0	3	t
47	0	4	t
47	1	1	t
47	1	2	t
47	1	3	t
47	1	4	t
47	2	1	t
47	2	2	t
47	2	3	t
47	2	4	t
47	3	1	t
47	3	2	t
47	3	3	t
47	3	4	t
48	0	1	t
48	0	2	t
48	0	3	t
48	0	4	t
48	1	1	t
48	1	2	t
48	1	3	t
48	1	4	t
48	2	1	t
48	2	2	t
48	2	3	t
48	2	4	t
48	3	1	t
48	3	2	t
48	3	3	t
48	3	4	t
49	0	1	t
49	0	2	t
49	0	3	t
49	0	4	t
49	1	1	t
49	1	2	t
49	1	3	t
49	1	4	t
49	2	1	t
49	2	2	t
49	2	3	t
49	2	4	t
49	3	1	t
49	3	2	t
49	3	3	t
49	3	4	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users ("userID", first_name, last_name, email, phone_no, aadhar_no, profile_pic_location, aadhar_location, public_key, private_key, device_token) FROM stdin;
47	Anshul	Kalbande	anshulkalbande17@gmail.com	+91 8308276391	975de4c466f01eed:42e6e10f82cc601db72a75b90779ca826c5faa498d2fbe5339ee06c549050db0230ce48514200ec6d16e7414d38addc239cec6475015f58eac0b33785ce42cdd	\N	\N	-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuXZUjrVc0+7v3+BDxRLX\nyNv8XMmqzY/zzZXGJvp6UcixYqMrznUCrp6Vkvtmvv+S0UZFYd0iBsf2vvBZ2vY2\nCBwsQmJ9/dm4Os9Djr/TfL58/QlHO8kKcDJxV5m49IoYIJ389uvmmPdEoaHn6AcN\nVodLLr2wqNLSTa0CH9RFyY+32/eVa+wRtsfr4qDXsPmW22MXkMZEO7/CuaPdcCeg\nj0rVsYdnrRrDW6ZJmho+UKOfZTKcuDH6zUsR0mLjVx8PNClEdOCHFwhi6hBPRB92\nG25f1HkkpSckAfq/+9uEemRHGolCLH6Nulj0ewAT2lYP8Jd7U35UyFut9wFVH5Wi\niQIDAQAB\n-----END PUBLIC KEY-----\n	4cd616a12088d9993a2fd8aa7d245cca5bb33228a8d2b2c7c0d316ab10f4192ff4b0420f117ca17736e6a81e095b6662e3745439f40524102412321ccabc4e7ac8d76dd7b36564d955c0b74a24970d294a5510d1b0ee557a81512b89ae2eb8baadfa1f07d56e5b8dc832838bb29ea804754545e79fd40dcd708a23e889b0183ca0d58cc7b117989aa34f045c125a4bb504d80d7d479ba6bd517b8ed5467e332e7d0c9cbb3fff9064574563c6ef1801cfbe9d5aa3d2ee04391e363246ed5d2e945990adf0a084b7f6f8f47158574f042ddb3592ca229df5876a58350b1ada8b82cf769b285e29b397409513a97742b3d864ded1efaca840f66081181a402e1fd44544b953b6b7ae0b2736e48e96012a01543124930403fc6ab06beeee2bdd8468531c814c8f4815cd603fc615766c27f1954eb93b6d8bcd3ae9a6a3f132705859d60a10baa865843a28a38d3b5657dabfca6fa7689b61b13682a13b9a2aa86e876b26625315dfd907f77715fcff887c45ddfa3a7f28b2cc36610123dd77e2b3df5aaf1874f180f9efc1a83bd2f25a2fba3dfe95092328e14bda39a73c32692571a20c70f9392f2067eae86ea5c0a8b81cc7038be60bbfa0714dbf64298d712a68b27c2555573aefda4eaa3f5a259cb34106dc5c21808af88125696d3ed652f32d14b144fc6ba9025ab0a00114a430b4eb9d7c9c9cc596064881ca78d9cd56ee1ab33b7fb040cf157a2a51a1586c9a0fc8723ac86c30830a71fa953671c03519d7b128e47d96969d643bbfd845e740d6e545e888c48204478ffa352f7f596b5ce1bbc93a5f86bf80ac52a76c6386e80587854b11e5b28248666782d01aa3d8a211cefc48867ed179546177d405d50c29cca7217ebf7dbaee18141fb5e0123ba0b7517a03b8704b65fedb11acb441bc6679099eaed3be25f8749efddd5a34e5ca0a7dcbada64fd120d886c7df63e1e3d9e19fa75e0b5435e8bf9ad88be6b1c833d647c2ea57be8bc37ba2eda8aa7891c7e1b8f97a26b762700fdfe0c7ab59f56d8e8b794e59cc2ebf95b13cd1bb8813ef7204ed07a406bbf1b70e81c95cd0fcaa11f03023aa36d265c6b3d8915da86e2cd6293e90f876960134139e795d82f2244320433aaffbfd985990d597cbda3320f863b9dd1c9a916ec745a183362ced48649b18a9cf420f4508fd72beb7d17138fc3cad2dd389a5582babd7e27a713e00c29345d2ba8c94e531fab7bb23986aed3c31bb1dd54baa4a2a57c56282663626de8eab1a171b22c23b9f763f9ce8f1cd4273ca302b7552a655110d1e6fba4b9468b11d84053830c31d97a5787c9822eb08d1c3c6c37144e1e5a9c06d4d387dad4bc68edb5fa82e01970dc70455ec1ef7d9cdf6c44c8c7357370d775dab1a25d2b5af22e875739df863fe8f4bacd7edbb87ea3598f238cb4effdd894410f89955ae7388ed29439a608f8df429cbc01df66e7d53ac579e0359e14f819e825f058a786845e32aca7797f741dc95e54c2349ce4171d2f248b5d997c92e8354d4c887fc6d4e8c2f4b146887a12602c3b99af48eb6318728480810d99af4e682601206518f2937fc72fe94de979e52177f8fc08c9138522f0e4c0d6de5f9ff1b80f3614e3fac8c6b4a54b2ac17157bc8475c4ea5e4e3ed8abfe07f954d423e9d79c5d1a0597b04875a7cba2f51c1a1a8b50466cbede2a1e32414c9d2b19cba15dd47ae71114a62dd560619963e045c059894764f2ea2b54a5b9a6cdc5c7c876482ba605a0bbbde7e4fc9952d08d6c46ee82704a0259c98f2dbe5d1b53558dad35cbd8ed1025298f80921290fe06f92261d21376cb3bf5a96704fa5f4d8a4a44d2b4809710b7678fe8ab134941d01345bf2b6b9149592fe658fca33aa5e40c27b79e254a68ac0d9db4289e7028cc1c69b846723e5fe46e2d9d595d70112610f3d3ba43501487f6dab9f0aa139d4b64a590c1eadeeeb7052185b32f1bab8e0349527198286ca02c63ab51cf18f0bbbf47e779b67abb2300ee6c8669d9319a8249e386ecd3037534f4ef68f77d6ead068e74650a2de9ba4a0f35b061bd9af1044e3dd3f3f95610cb77497cf29a77bfa935b91929cec5cc4460066e06e143d24dc5cfa1a7bc026137a97b49337dbc5aaa24b70798d1d7d74b507fb5d92aa944433e20e27eb3e76fd60ad98b9dab96d287ceb7b4dcd5019a2a0af596c5f8dd554fc1ce7994896e88d83b78e9b820b78a9aec8a6d1aaa894275d83341f83968b22b6c24072ecc693c0cd87494aa3e6218742d9c5034aa4b5ed16e995f87036ddf2f0d66bf5426acb53a361c8a42fd90045be70e5b56e8b4586f32c3d4f32e5f748e8adcf34c7622c3ebdf2d1d3acd04dcb3d4f29aa0ecd18e2cd19fc8cd5b5a3b2dbdaac9824871b4a55c032f7ae89cce6acf5e28ae4ff	fFHH6kc2QLSlEAb6hNGBSq:APA91bFXqNerZagYKBxZlCrC3azVfLFfRzzlRkY3KqssdgiVrAiOLGVWzF3YW8ys6_scUnXzDmBiGFOW7QapE8IOeIZJbCm9ae3YtifHCixxr_KplU9gLoA
45	Anurag	Mandke	anurag.mandke@gmail.com	+91 7385100700	33c80ceec215bb94:08e25dc31afacb2194b041b5736a6354d000a1821ca5585526322b28d3b18136c60658f8f913c596ccd4f37103b82a9f2da1fe6b80019c97c33d0e51c6e12e80	\N	\N	-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxoE97iEAVT2PUt0IypZw\nGN1KJvnbhN4jh4m5uYm0PS7pKZtRH7NN3WzVrAPWS9HxJcKiyWD+jQNjgIHHp30M\n8ULD2emb4W/u1ko0oi140ZwxUDdulvXiWPotCpXSqcrCqahn2PFInI9oIduIc6iI\nTRj4qJIENMx88/NDDCp4QLHBmk4XmSCGF5JI5XZWGFZm/cR0JfnM56tUjQgJ8HnO\noxhQ6xkp5Ce49Caah8VFOWoVYzDIbvODC78tXV6+Q52bvggsn73FAVGZu6h9E8PM\nB5+q8WHFFUax7dRe7XC/ttgok3uoSAArOjvuqI4EL/RGNusVyFEHJNstQIUqh6Qu\nCQIDAQAB\n-----END PUBLIC KEY-----\n	b047f34ada2029c908b13f0f94fbb4ccc3d168e7d0f8f27bdf7a7e45c04f8bb44266e83572b74cb64a4620c9e2fa3422839c4525a30249885ab8a9f739c2df0a011524867ea3af12b09e157d52487744b4c76818c89823fddf6268c82cc0d562a31183d43e1a94fea0992504ea8397e27d31aea764db64ac7ce69d109503c6f9baf24d80bdf7dd1ad84e526dd163b6220fe37f26efc1630ff035848b3fbd42817eccdf526ac2efd9963adf5a486af0c7b4e993ffc33052eeb5866ab4bfdbdb94cf4a61e3a060b8f6ad1b119b7f953897e4baad44a687b89d40c00629440218a99f95c8856caff91738f5489fcd839784903eb6bb5be6071884b183f966b2003cc044c4863745e3258acb5ddc529f4a8ad1f56e5290d149d01dec616848bf240819719690cceffc5cb8bcdfcf2124c84d6f1bd2def015da8db705066d2429f70092a5c5e2405219dab7bb04da8eff27305fcb9223e6dbe730f539fee4203f64c3743a9f837c2ad417482ad8846a85783b89e680f37bb9e231c5ad691cb0d4f7c06a726bbd0368bf948a9f3443e3e4d1571cee5493d827c5a917a60ec5d486a5853e4e8fe591e986b25b044eb342bc62122e02f5cba59798fee6a9d46ae9711b223559c8454676a7b7554bb50719a81e7a8c4a120aeb8d79646e6bde555979fb79711de6f90be244083faadf68da26dcc84807b2166c3e827dcfa620835b52f7ef3ed23254505729bbe7a13659acdced689bc2f2db62f414690a2a6ba52993aedb496b2bea21350bc5f2480b9083b40a305847ff05dcdeefa394b8bcd819eb3690f3fc001d3170c837a4eee45093562441a11c1444d6239c3e476e51b3dfe7788481e594b1c071c4b73c5e555219e8ed4ccb2dfb9653301f83cc6a22a9f67efea517ae1dc69bf783efa37b1042c128564cfd3a9fe5437037ad11ba49c2dc8cff5f54027606476537cba30cee06b7e02106646ef4d968c305233d7f2228d538aa90d80359d85b596fbc56dbc2fd05147b03d472a2ea077daf564c541f06617ad71d2f3d13f9c0229df92e400d5f12e40e5346b93dd5b3e0782fb012a1705e874685e80e5a5550c72a8956e4344e06ca24c853c65c842adca4a0479bbe4bfccd90122435afcf0f669de66ef82b91a152f524e58459ee22dd74dab0e52e3e1a98efb00ca4d0e172b04b711284514f830db4a8cd780c0941e2cda1a22b38e66c3b3516d8e7426fd23cb93361d001f78348f5ff4b893a29541d5ffdc400584b7b9fe7d8a3f2b683ff8b88afffeeb66a32e166d8dd6d546054fba2a9a1050573cddfac78bf8909ab357d468daac146fe94e1b60ea75f86b6ca325c932eae0f36986b7d6d75136d3e866f66c63efd2ad38a2723dda209c68a252075c3673ba27727be8050e750e7cf4a0188ce9314470ce63dfb460b9a671c6eb80865a34992a75d7746233c2ae1fed6643ed69bb01f87c08eb6f75d1060bddd7026d21f052682e32aaf007333f866c9065bfc1035e9744289347b26f7f43a75381c2120637d73c1758e0338870674669896c7a86a42bd081e419335fa696e435fdf47e36247664601769c4f35d4f7dfdae5f7af772693ae0797093630d9ab5963ec83a9b92ad3808d61bee652175a7028c335ef5dadfabf8effa243019deb38c2fff23863607a83cf6d65989f593a4deb07a95504840aedc8a1f242fdc1ed548adfb21bee35ce91515bab478aa3a178756bab016ebe75657f501ff69ebfc0f396ad5f98faa61880fbfb90b55a52164ffba9b119179296d74056967e9630dc58636e5a02c110713a96f15221e0f4a070903aa9c3cd35e8aeded2d400fbbfb9a09911c6204020df2129882f1e1998f5cc0d784d65cd0c29f6fff7953a3b80f06484805cc9f6d9df56f747978ce06e778a79555a6f282f63d780b2bda57e8444858cb1a573d0a82733738519abd4ae75dd6a8d718acf69dbeb1ca7c980aa631d6c2549ee659d17611f90a561abca132d1f513d60ea5d9ed3949d2f97b3b655b8ff883e14f31da199268556a1bdf7aa8e44f2760a507214688a4ff2e80a6c55c391fb8a738e8eb0797e00c017f0593299a87a51d327d3f761242c936a51cb4597fc2c9354428f469c38b2720bbbaf62a2a6c745de43e8acca4915b4649d2ffb0daebd5bb6111c3ddfdeb1ecd7e6d54c42118492c6a334502bca797be66a426c2b157e9ee6c2198e8ff356df34e55c5e2fabd29937094f8795708f93708e927c90220de229b33cddd6eaa4a15174e757f7d7df339839b1fd9bc8b736d14445feb9ab30ab75e7399a4f754602341b2f0ea442ef632158b15217f9d0adb0fb8e55ed34ec92faf7e272d25ce0764fec2d2c1eed2de8304256d0769d354047d9134130fbe4568c0fa9a68019cc09cf49c9bd2da1313227b5f8031eea1de1ad	f5WBPR1jRruFldCcuFP7NK:APA91bHPSRR8K1IoWqr2Ywokp2ledkTFWnEdVdr-l5kasoFR5FWLlgplNxAtu0NpFmNY5d9sTvTsjF-cucCtIalvwCMGjh0kHnNoeclIu_aSi5tOFcbDcxI
49	Amruta	Kulkarni	kulkarniamruta1979@gmail.com	+91 9422000089	4fd54ac6c012fe20:176b992f5025cda11c0e8f4c5a82be0723e4836c660f6aa7b29630b1e1405b1c4471c45d6d89f0befea3562deed0a603541cea3511e69e598583d5fde92d0acc	\N	\N	-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAugtMwy/PeDReIzs7lhH7\nXJzgzXtRCFZW3O2cN09PLiNK6uHnzlD9NZG2zRyxnPvv1sRl3An8ZwGppdukYomT\nWF6hgtXOrSF/XIv8OAtQVacnNMBeu8zTZoWBhlbGFVpxldA8FFWO329D1ukOe/B7\naGeqvBoS8PZVv8oZvvB+34ls03kVNIlAEhsYR7yhNskdFxXBCsMTVrER+RJ3N/+0\nLvJXB8SzlnzOPqLqaQmFHBYTuYDtPSXhxuqchp8s6q0qS/QakqRDnBJ0eodlS88C\nsB6zKRa4HDMEaGJLGtAxxz0fw7wRJVJhhmx/sj8NwLrlC3sFshm3RHqxL9fa+/0P\nRwIDAQAB\n-----END PUBLIC KEY-----\n	4a0155f17beff73efda758aca7d37541ce825f1cb2d5249a842b30dec15fef1ad21b4659aeddddc254d4e8ad11e730648d7991cf1af8e4af10cfac854770d7f325b29968cee77a15a5888ca319b8fe3a7c8a4356206c0f43668e51ba9a7d56e28da2f37ca56635740c2a2eb4ef5ca7036167a9e4bf99c3b8358faf9c3d6d3c446cb29dada3e8e6d2a0bd7ad1aa055afccf0cff16f91b8ae30a7d51341f114f508da88d526beb251bf2cfb4b887ca195b0329bc4e50fa2ad590fdf09c1e35a3c661ab4d62f2b563e1617bfdd8dce75c4708df52f7626751bb43db041b5091fbd44aaac3c296461e3ac4fe9cd2257659cd8320c6a148907d069c384c844ea0469df0d1ca7ad658d01c11fb2467a0ccf9859d24abea3c9d1ad2123c3f1c50deeba74be0ca6de66b2a17adbecb4de21dc544853d905f9306666a6c6cd0c6a546bcb9662018bbf8870dc4dd1bb3215c44b399af724a9808c8017f5312be512a81ef88e4f73b08b1f60ba33fa9bbeeca61e1e0e353ab9777ebdd822a8f0e45845bed2c9c55903197da0bf90a18af44cdbadf0df252b3ff0544a833461fa0a356f7dd4b38165226904b540b56f1f31a17bb86605a0758dcbf0952ca983639f22217031ffcf065fec66b99b7df23b92db4f559ec413d60edf8f3ce6ef4a29398b85f4e5da6fe3984d57f7564f49699fb60800c540228d4e8d30cc6c69ff4e71b2c3a65dece6b8922da90d0681c212d4e39ac73a47303a3707c222b2f2615150f3f545d86b7d5e43a470ff282d0a0d70f13090da02da03d72a381acb143d958d69606a5be823d9464624bd8cd424373103308670b36fa287cbf2e583fce06308da266b3c8613a1ebb9368250f85f42c2f15a5ee0d7224832ba1f41ba6880512169a768c5dc44ce277f446068f6650ad1fb2778308de16618946eb1c9a3afadb5c99a4f8e0258b522221db4a8fcb6d103f3839fedd37948078c3b90e79a8c0cd169947609537d79598c92cdabe510560b39697c259ff5a4ea790554c68d71fcfe0251b8310e0cfa38624c774e3dcb064128ae78bc6b6b5da955a93d30f4cb3506da2604ed42fa5e879b6b433f84d587045527abe5233818964ad05e4aa209dbc28fd9abe79c440754b9c48c07e8ad4dde163e49d025976c31244c7acb301eb6c790e5772ce9bd48433c3ddddfecc3717b4586ce822fc02ae3da3f2395767c91dd9274bd2268da7b22b4693a092643ae7ee8cfef2efd2e03563cb0bdf66898e043ab6ffd2bc88918875df0aeea033fec668426f5931d02ee4f881a3e226531941f52293a9559345c98f28b70bc99becc73d3b2ff49f20265d24385c08c91f6397b4e749618572adfe7ab9764177c3c52cc33b2915d26b474e6d1a963acb6a872ca2426e1fe1dbcde09b8d65e6464ce6888291b283901c018538c2081181b6a6bec60ef8e5a97ef5a0cd318a64f4ef307cea1fbd908370cba8a3346c63d00231f73e80a5e4f390439c3daa912ab59b4bd894bd87a8a726fcc5274aa4309c6755de6488cc7398967724ac1b700b66a839f302932a0fc965ba38a58da1723f0cc042da5235a5658c260d0888b7e4cfdeba1cb5cbfc074b3f3ab0abdaa24ce9b07b701c1c9798db4f8a174198328fdc643389228c9504849e38388fd7fcebe0704a5ac167a0046a6133271c38a40e60168f3f9561f0b1282c3cb20ce7660ce2188a67575e5851d30b88bb9e9ddfce068eff4446be0ff788884fdb9a7ad2b7171aac479c6ed8dec6c2d486a12ca7843fe7d1d874dc41c6a1f465354abdd686bd89c31e840764aef6db6afa38fade0381f0601c73e3a7334ae64cd7aef33f344f7b088771895831998a1d54bc7ac39b59298e4fc8e018b7c1216e1679df20e2c8841286827f11872df7a926c85a39df46a897bb087520d9d7c467776fb4eef1bf17f134d73982224e7de59fb588f318bcd712df38e4f6f78726255099992acffee77c83c8e43edf78b53fdf67e5ace1e42d29b24f564f93faa8536bcd4487011b638f19f544f667753cbbdfa7c86b50380bf21c6eaddc707c2ad9b1df7b0e61d4331829db453e3840b66d81b35d9eca51ed832d85039f003716f5fe4c34e68d4c917bcf1cc36bab0e7356ab1b7a6de1100357e99e886037ecb8f3c1c358acf8b6d3cb73eae048a7edbc1714f82c3b7180454649c872525d4dcaae48537ecaed670a2ada8c5cf6f90ab38a8a27d49fb3b53d6d66a547d8e62fabb6992fc55a50db79f0015662a8bc7301e2a6a6eb64188491aca60719d3fd60b1f8c669683dd3aef6f28010f92c488c4908d9459688258f816cd55e9df5db288af549c68890fd93b43a2fd783073e7d82a1488289468c1e2d5c2cf36883c9f471cdc561b71899e874acbac4bf33bfc61aad3d84d4678c3ce6032f8165e018ac	fYY5_YXxQVGTS0o5M8GHgB:APA91bFA3Y9dutZuFFujxZAaFvZRULnvtUafGXxnLNtwU1ZUZYLlXaMqhRKUhb6Sp9ccnn6XDwgiDpc1ZB_mIrRP15UT-ZFc3OOxlEgfCE0RmgikCk9oPnQ
48	Amey	Kulkarni	kulkarniamey2004@gmail.com	+91 8329654110	6b834f76bd96b105:4e2a9df7c04af8a55675bd458073ad9fa9c719a4aaeed0e3100c43bfe8afb2cf3398cc8af2e45e1b9c3d3e34fe6d7237ef8de0e8a1caa2aa584a9d07fa8ffe65	\N	\N	-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqHdpMr2YgRFyUtKXMUaj\nCspfH56IcRwg22aeyHD6O99iaJKoYFuqqQZgZtN5rDLcyH4dVu4CyHmrE6RbWOlG\nvwOrIhrEGG4CKu/pDSn0/0PZb1corsvAxG8AjQPAQmZfHTBgJ8pFeCQImYANJ4H/\nUuR5WZa5njarPpGAfDU603VywqFEal9FY79oI6CAhRmi24wBv4vqaOV1P7szbl20\nh+ehLzwhm1pWM+haOo9d+NLqq8FlMPmOfYDd90CiyGo0ORmGDODXgLhHdJdCl/nA\nDiT76xJvjOvqT0qxqZ0F2jJuRyYg/rBgKHan6prHgdJNYoYvWcvKucJWyOXhVowg\nawIDAQAB\n-----END PUBLIC KEY-----\n	0df283d3f6820336ab3b5b15916ec7bf7c5f8dafd826b5901de00fc6bf65289b7e01d8dba0c60bb4e1017115a3725fab4a05ace61791bdee9212fdb3fc5bf7584b96a4c43da6507e192ecf5547418cd893aa920e595811b77d15494aaf25bc4c4545504b07288a126b0027258b8c154a4833f9a79c7f02ed84335a214424a0aec5fa88cd630566668f0039a01336c931fd8c72403d726078c49a96b31b810323df0c095814a898524966bd780de3adb28c5b7045425b1a72042c411af3d08d1acf99162f839b213e1ac8c02249096a74080de06ef5859a1ddf6aafca73c834b6ea1807eee57ad8a7eb8da710846741df412eac03b01e42f2c55146161cc71bf41f5e3ae7de4acfee9b18f2dfabea349ce0c8d1eb2c7d566ddc0581a0ce70ecd4f4fc89c9d215f07225142caae3504dcdc4f99381de07aac151fed0953abfd72a4e8af1cd78fd81485c82b7cd743134ed036bf8df245dc0f7c8ef5a4d11702039488c2ae9c1522e01fb926ba611f5f97098533c00e684bc475c54780c1ad75ebbbb15c2bccc9cb8f8cbf7c4a2586baab0463efdf50c34a7d8ff82f6fd529b82ea90fad3ba5196ba308b57350fd96b256dc6e3992d2af2cf309300dc30dbf32eddf3a80b9d05b9d5d32eaf128f87406a41ed005954bdf32ebcca09d9708d6ded74ac37ed8d741a83d896eb5e61be1eeab59453015c1f03d0fbfa5ae3c596a291e51d7622114e344617d209ada777b160959160e7a30b00ac5a3d8fe09a8cfd70042272ed0151ad057026a4b465ec3a61af8455f29dbeda343e1efdf44b69ffc74ebe985389be30a676d9e85c64972533f4e46c60aa89ca3c6b837acbcf05e253fa61e0b41954f4ebedce8490c3179d73f0a9270b034071987b17877999deb8c231bf0ec05d8ffb217f2af56aa48567cea311c175fa37173fb6363da979eecda7793093d1dcbf20d8608971f207e64b22cef9c16bf635fc22f612cc7c03540c6633d28427a0f551714d9bcb114e8a0bce81b2d89ae50d917736f720f9f49cf309e0226e86d2cdd45da5c3419651ff0be7526b4e45a0e754258634be58ea7abc37d431dacffc08b0bd38d550c24d42f8d7d3f583bf66ad97e2772f38ef5971c6e4ea17f615f1efb63100878f810cfdff119f89a71c69920e20da4c8f875df1616b3ce3d95abdd417b015a9e3c841d4a5bab4afaf186be7cb6b0a2c1afe59c0d14822250ca92995daef6c5607c8ef40f530b372b71aa987caa6fb3b629f3bedac4d53a5e0fe401ae7b4a1889cd2b881515a48abbe08de8c63d47900f3b01ae5e301a65b047a2d1f63f011bbc53b71a4385ad000ff371d7aa83a89be771bbdab26a3c00d395d223d2ffb6060fe5d865ceda24225a17f65765d19c557e55aa7e459468f7f9870ab6c3272f20687456ee5fadbe09c80b453a5ff67a2846d441be5323035206a2e519f21f14aa6b7be1cd3dd87076d0316e3c79988cf16280e906a3d3afea418ebf18241bb024c137c9e49c7914fc8f29a423ed5bef68966075335bd047cac6a452edc1d4c007fbf2fe8a3483a679878b24365a8b16ac5b39502f5a8e6b63c6be5030e3b3a80eb8693cfbb6f1fcc975eba5c80ad8dc72a0c1142df7fdf3db3f031f7a3fb77d4e8a4f7db863ddf5ec8c879d891c1e9a6d589d7548ef3a404685b1173e1251fe819b7eaa3823c577ed8498df3b25001914f9707c53eb135213e32ebec4e6bdff5c01c7782e73ce6948944d2786bfe64c2e33ab81ee31f6c308b039cb4eeac6925aa256d553c27fcfee795bb5f05eec9991254bd3a8e73b87e6a616bcd3492c5f23d0b6be43f4169579b3540cc9f5a3ece835ebe8b9f9fbdcd0336b75da0680b87a45e7232be4975bb320bf1b75a70f9555a5333653bf66a6219da4fe6e79f2c19c30eb26757b2b83b36e0a4e2f4cfdb87c316b07541848564f8f19280771f5216c2df15cb0c9dd747ee98648a7899732fd747340b986c993cfb54b5fc4a83795748f4db3069fd1e4850f22acd7f422b652bb3bcaa3d539b4a3a1713e398022675a6cb3a6eb215653aba66c2bfafc689f6fc59db0b6d1810e145db70c19b789d6a4d5f6216f37a31c98907814995a0d793bdb6d5c9d59601dcd2fe23a14a91ebb7227c64496676418726ec151b014461f6e3da583588d11508ec44eae28b9f715e694bc9118107ad7999693bcaa4d340bce2d45c3c142f4f5332d4d37b1660d23689a08d0cccca186a8a5f1fc15f30b6e3dedbd690ce6b12622dcd08a714b206c0d2ac1fc14feb39dde70166d8c554786e0e7eea69e6d8d745d9e9604e8d422ca53b0544702f76bf48332c612c72da99af24be2011f5293a5cde818d5790281553e3394577d57ecde23641fa9ede32564a3fce328e19945b6c3c4e772c5d613d54b347be31de8a2585	fGnuH7IdSNO0b0VPq9lm2X:APA91bHR89UUx0FFi-Enhyw72mDE3DRGHDsjSIHjYDxfHwkr5uKMOrTsveN8oeIjmF5mFGoSWJRgCE0UNOWZg3JPcalFFQMlA2jL55A95l90QjCt7gToLpI
43	Advait	Joshi	joshiadvait07@gmail.com	+91 7249252910	f6ba72025afea016:ea9690b9855ef37140766d05771e97d112854125ee942f16c19cd879774ddb5af1e5ccc77d73ab65a6f6565d335109a6b67d695fd620950d6c88f325433d1fb2	\N	\N	-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAztIByHvLDEj81n0hExLG\nn3FYcMLtJ7buHysCPmStuxvDyNxVV6yByEBCELiiaQTwP86ebP78fMxSAbo3Im3W\nErrWskT31DiPvlaGDKvw+QX8Bck7DOA9dz9IcWR0tdweXdyh8Znty2p96mddvbl3\n2QE5z/M7v4dgkfmEaA0h5sgffm4Z+Xk4EsWT79FXVmd9II0O3P2osJlMd6yhhxz+\nILBQ+fptcaiYE4kr6ImIwnH+lxHXdXo7Y1tU/W/SZWYf1si8zZtT5jEsGweKs80/\ndwwyyyeCbIXKKiQ/OiuM/DmBCp6r+SJnIoQDLgb3eizRUtHKXUhvjTjK36E+g0Vr\nrwIDAQAB\n-----END PUBLIC KEY-----\n	b7e806a43603977a143c6e4269bfe890341d3a4152253722be32e8efcb2a0c717f662cbf2f9257a13bb67e990998bd885bf4990685b30099ee3742432d82c39fae166c0714f53aa071bffadc560267f3da59e5741a3698b57ea7d921c0dbea73a85ca76047a4485b5669ec0658b9a595c397469677582ba22bd4e94130339ac64d226892af0a9fcfd4b1c857038cfd1300295091c7d783a7828121f6d36c4d6b9df8283d0690fad3684d65ca01b4425c761145dd1248c7d8acf647ca464197d69b8a359401aa1d8a2b21d6c446835e6bc0679b34069f9b7946e793b2590ffecce077e83d52571dab7a8878a746c000d1396d9823dc28f332d18fbcc230b60b4d2fa3731e8b68d2da54d9d0102f91877a43226c11de04593e543ac784f7f2f2225dbf55f82985432ade7859de9fbd01699d85ff414b58ae76f21e6235bf7cdb68083922fe65ec1805a5451a441c3ddded6ecf201e2b3ec6ed572f994693d228954d6524cab67ece3b3ff36a68f3fefd291f41f5e97eb3781e6872b9b188c1b8d35c9625dfdcc0192b2183b78623e712e2b5d77389b95de6220560fe50b5f23d49f22287b28741063c8fdea0ac0e80ed41eac764dad4cea860e4336e494b0fa0ebf81165f3a7504f098b69ab3cbaacd1308fac12eaac87a9bfadf02cc56ad7e3100cf17100c4705d2ffd1eb8444a37e43a032045b10e9fe5a950c297f58022ad89becb76fb54e945cc424638be150dff7624ad7dac0bd30973d9df5a27be72355c170d4a7853ef33120c69ed16c038fa69c9f5e44adeb6131398c456099e697218acfa3829e3f0e55106f6cea9f4c3afc95e361beb1a4a751f62b1eafe8d63a35f09fd96530f5b32974f31345f6b66eec239f636b09f275f14d4eac8f437a7b64f482d7422860cb8dd5a5c2126a1f72f2acff707284204cbe81f46ea1d0c23691aac0abbf92daad1fdf7b882c5b003417c335caaa93fb4b92d1a3b5a416ac7a841c7ef71a545755f50fab2ef6927c47400df038ecf60a4078074ac6388c8868b78896dc62a13bf4f85b13ab6e14403e9dabea512dd492f4b3bdcf8c929370955b3057ab34cbca1b3979f61b3b0c3a67c1ba3db0fa4ce980facb778273c6d316ea4d64a10faf60929089bcf806561f92d18344cc21adda28ee6a5113961af84e5a78d5dfa4ccd1fdb43b450ff75ca18be85bb4c96b3dad49fd3ee6fb87cfa4658d13cf70448fbd5d6630d5eb6f2a1d7b8a32f5cf470e39ff5d7e7d2dc5a4c6caec9ddd152bef156c9c810459ac32c227130b6ad047c83718589dcad1cbe973784ba6708da08ef6c68847df4f435cab4cbd137b9fc261c0c7b7d95d1cc6a2034e1ef63e16e1862490614f18eb8631a895da21acd8a1423b3f4968b3470907e6099617d8320e6f4a85ce2de388a9c6ac620c8280ed05ab81cae39aa2ecac881f8366707a485a81ea3d5df0dce595f2ab9780ae5ca1c6fc9a4916f06e902775af1648c8231e3e04271fbeaf9f7d2d8e2b5a98826c845d88140d8cb3086805d025bd81102f8f3026eced10ec34e30c77f717364aca3ae2e00d889a7cbc44bef0de08944318b52270727c3ab88c2eb74bcd87bef189f793b40a62d4edf1f3cda02c4db26e6c4be6282c5186ab46597bb93eadb2641eb6567fee273ad4a7d87aeeaa88e196253ec7e23d10966fd77ee894407c28b70fd1ed9f244497ebf3558c05030105f55eae97e2d7a4eaf9e57ad4d7beb721bdd96d443b54040ae420fd17913b1fa2de24402e7e429e609009bcbe794d1f3c43e52a0d0aa2eee89700abcb1bb9bd8a2882ae4dbc010eb3af18e8ed5273be876b94fdb9d6446d8a66d1a4cf02f03ead3fce6a0d6f00e997e98e23a6f5e0f08f5437399a59766836b5de51d145cd262debd66653494ba5c8f270eb90dc8036c403fd0ab5648ef27203dd1ddfa73eb3c9988f6c78952e614ecbb485dde64a15983970ed55cba77e82154efb7460d4eac303fc519296cd5274432ef00763c1be41984efddaebfb2ad2e8bb55f27269dc3667f8c41b4e3ed94bc765ddb8b601c23bc2f15bc2ebd1f6d1d128c156e3a83a2879f0c0ec60b0f5406daa419ef95277e70dd4c86d9a4553437e232fb0a5fcfbc5717a1ca61d0608208d22cb1cb93e22a6b4f97039aaef2443eec63617f152650d472a2f078b9fd2f06b6324fb0130dc0b0e8952507507427b94cc471b1db5ce6b7b306662a3e008f97088692d4bb9e822111ea99d8e7d9bdd955f1174d301592647ff0858d8068d4306f0de68a9e72d46f7acd556264690208d2d9ecbfe3b3dd01b4e211da1dad9a215b8c76fb7a785d2897cc8bbfe16627cb2d2ce2183a0e6890c3f3c474690685fc9ae8ad9dec8c052dae3679c810e8c269893a9862d20d784717d262c0322a250cc59243fac778df18	fDlKZWu_QreUFvz0gvg_oK:APA91bFi8albM1vX7MaiKSuj0c4he0BQtb9E2uPQqJzUlhqA-fw3qF3o5p06BUaue345_Fgm18jb0VNxro8oDwpImBVIpLIoaG3op-UxABnOiZc3AL-dxls
\.


--
-- Data for Name: verification_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verification_codes (email, code, expiry) FROM stdin;
kulkarnimamey2004@gmail.com	000070	2025-02-09 05:06:19.389088
anurag.mandke@gmail.com	000007	2025-02-09 05:13:20.985978
kulkarniamey2004@gmail.com	777077	2025-02-09 14:55:01.129684
joshiadvait07@gmail.com	007007	2025-02-09 14:55:45.822286
kulkarniamruta1979@gmail.com	070000	2025-02-10 04:19:13.439971
advaitkjoshi@gmail.com	000000	2025-02-08 06:18:22.724334
anura.mandke@gmail.com	777700	2025-02-08 06:27:44.499808
tirthraj2004@gmail.com	000707	2025-02-08 14:23:28.006533
pranavsonawane479@gmail.com	000077	2025-02-08 14:24:30.733872
anshulkalbande17@gmail.com	777777	2025-02-08 21:13:12.884407
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-01-21 07:53:36
20211116045059	2025-01-21 07:53:37
20211116050929	2025-01-21 07:53:37
20211116051442	2025-01-21 07:53:38
20211116212300	2025-01-21 07:53:39
20211116213355	2025-01-21 07:53:39
20211116213934	2025-01-21 07:53:40
20211116214523	2025-01-21 07:53:41
20211122062447	2025-01-21 07:53:42
20211124070109	2025-01-21 07:53:42
20211202204204	2025-01-21 07:53:43
20211202204605	2025-01-21 07:53:44
20211210212804	2025-01-21 07:53:46
20211228014915	2025-01-21 07:53:46
20220107221237	2025-01-21 07:53:47
20220228202821	2025-01-21 07:53:48
20220312004840	2025-01-21 07:53:48
20220603231003	2025-01-21 07:53:49
20220603232444	2025-01-21 07:53:50
20220615214548	2025-01-21 07:53:51
20220712093339	2025-01-21 07:53:51
20220908172859	2025-01-21 07:53:52
20220916233421	2025-01-21 07:53:53
20230119133233	2025-01-21 07:53:53
20230128025114	2025-01-21 07:53:54
20230128025212	2025-01-21 07:53:55
20230227211149	2025-01-21 07:53:55
20230228184745	2025-01-21 07:53:56
20230308225145	2025-01-21 07:53:57
20230328144023	2025-01-21 07:53:57
20231018144023	2025-01-21 07:53:58
20231204144023	2025-01-21 07:53:59
20231204144024	2025-01-21 07:54:00
20231204144025	2025-01-21 07:54:00
20240108234812	2025-01-21 07:54:01
20240109165339	2025-01-21 07:54:02
20240227174441	2025-01-21 07:54:03
20240311171622	2025-01-21 07:54:04
20240321100241	2025-01-21 07:54:05
20240401105812	2025-01-21 07:54:07
20240418121054	2025-01-21 07:54:08
20240523004032	2025-01-21 07:54:10
20240618124746	2025-01-21 07:54:11
20240801235015	2025-01-21 07:54:11
20240805133720	2025-01-21 07:54:12
20240827160934	2025-01-21 07:54:13
20240919163303	2025-01-21 07:54:14
20240919163305	2025-01-21 07:54:14
20241019105805	2025-01-21 07:54:15
20241030150047	2025-01-21 07:54:17
20241108114728	2025-01-21 07:54:18
20241121104152	2025-01-21 07:54:19
20241130184212	2025-01-21 07:54:20
20241220035512	2025-01-21 07:54:20
20241220123912	2025-01-21 07:54:21
20241224161212	2025-01-21 07:54:21
20250107150512	2025-01-21 07:54:22
20250110162412	2025-01-21 07:54:23
20250123174212	2025-01-25 03:37:01
20250128220012	2025-01-29 17:09:11
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
video_bucket	video_bucket	\N	2025-01-31 10:59:14.946691+00	2025-01-31 10:59:14.946691+00	f	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-01-21 07:48:50.060436
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-01-21 07:48:50.079854
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-01-21 07:48:50.088098
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-01-21 07:48:50.123076
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-01-21 07:48:50.164177
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-01-21 07:48:50.169768
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-01-21 07:48:50.181954
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-01-21 07:48:50.189202
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-01-21 07:48:50.194242
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-01-21 07:48:50.204058
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-01-21 07:48:50.215146
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-01-21 07:48:50.221584
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-01-21 07:48:50.227374
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-01-21 07:48:50.232592
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-01-21 07:48:50.238595
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-01-21 07:48:50.284536
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-01-21 07:48:50.29119
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-01-21 07:48:50.296762
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-01-21 07:48:50.302788
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-01-21 07:48:50.309781
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-01-21 07:48:50.315217
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-01-21 07:48:50.32731
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-01-21 07:48:50.35941
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-01-21 07:48:50.387896
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-01-21 07:48:50.398803
25	custom-metadata	67eb93b7e8d401cafcdc97f9ac779e71a79bfe03	2025-01-21 07:48:50.40524
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
05f70130-53f5-44b2-ba06-4a263e807d01	video_bucket	67a84ff8d7e31a8f2cd4ddff.mp4	\N	2025-02-09 06:49:52.28454+00	2025-02-09 06:49:52.28454+00	2025-02-09 06:49:52.28454+00	{"eTag": "\\"65c8bb5ac22cedc695a77f9e7a143b10\\"", "size": 2720559, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T06:49:53.000Z", "contentLength": 2720559, "httpStatusCode": 200}	44182719-bc92-4e5c-a1e6-682558243e75	\N	{}
94c42ddf-74a4-413c-b00f-faae0dda39a9	video_bucket	67a3161693fef3e58355eaae.mp4	\N	2025-02-05 18:55:27.220605+00	2025-02-05 18:56:05.102696+00	2025-02-05 18:55:27.220605+00	{"eTag": "\\"0504da71e102fc65143314155586872f\\"", "size": 4493057, "mimetype": "video/mp4", "cacheControl": "max-age=3600", "lastModified": "2025-02-05T18:56:05.000Z", "contentLength": 4493057, "httpStatusCode": 200}	b5bf1305-c389-428a-9741-df8f1a109382	\N	\N
6bfcafd0-2afa-48d5-a57a-9a6b9620ab84	video_bucket	67a31acfbe1346431836118d.mp4	\N	2025-02-05 19:29:39.827011+00	2025-02-05 19:29:55.757902+00	2025-02-05 19:29:39.827011+00	{"eTag": "\\"e3c9bcbc2bccdc1d21661f42dc961f7c\\"", "size": 20907768, "mimetype": "video/mp4", "cacheControl": "max-age=3600", "lastModified": "2025-02-05T19:29:56.000Z", "contentLength": 20907768, "httpStatusCode": 200}	beae1c20-fc46-48d8-bc5c-ddf9e1224adf	\N	\N
af683c0b-c166-4233-a755-f3ee5404e548	video_bucket	67a66756c499f0015ff0552f.mp4	\N	2025-02-07 20:04:41.901042+00	2025-02-07 20:04:41.901042+00	2025-02-07 20:04:41.901042+00	{"eTag": "\\"5c36d4fc7e8124ff9c8ba363658f980a-6\\"", "size": 29690627, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-07T20:04:41.000Z", "contentLength": 29690627, "httpStatusCode": 200}	810c2dec-c777-42f6-8acd-1b1ce928bc12	\N	{}
b21a875a-588c-48c1-a543-914fa22faa4b	video_bucket	67a6f34c62e44b89384f25a4.mp4	\N	2025-02-08 06:01:49.619426+00	2025-02-08 06:01:49.619426+00	2025-02-08 06:01:49.619426+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T06:01:50.000Z", "contentLength": 0, "httpStatusCode": 200}	0c1c2fa3-7e39-470d-b6fe-82ed7bc083da	\N	{}
8bb8ee68-9a6d-4f13-9838-89c68e90c3f7	video_bucket	67a6f4fd62e44b89384f25a5.mp4	\N	2025-02-08 06:09:01.924602+00	2025-02-08 06:09:01.924602+00	2025-02-08 06:09:01.924602+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T06:09:02.000Z", "contentLength": 0, "httpStatusCode": 200}	95cbc0da-9f38-4798-af00-3788259a6f87	\N	{}
88125764-210c-491c-8b33-14fe930c0862	video_bucket	67a6f6ab807f2473a14ee5d7.mp4	\N	2025-02-08 06:16:12.124835+00	2025-02-08 06:16:12.124835+00	2025-02-08 06:16:12.124835+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T06:16:13.000Z", "contentLength": 0, "httpStatusCode": 200}	45b043b5-8a15-4137-aaaf-ce08e491faf6	\N	{}
45ff8b1b-f709-4e30-bd28-543daa37993e	video_bucket	67a6f706f2db7f7028159ce4.mp4	\N	2025-02-08 06:17:42.538942+00	2025-02-08 06:17:42.538942+00	2025-02-08 06:17:42.538942+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T06:17:43.000Z", "contentLength": 0, "httpStatusCode": 200}	98c9662f-5dcf-4b1f-86a2-6db8ea2b2583	\N	{}
f9bb2ef6-149d-4931-a3ee-d6fc017fee68	video_bucket	67a6fa43f2db7f7028159ce5.mp4	\N	2025-02-08 06:31:32.637915+00	2025-02-08 06:31:32.637915+00	2025-02-08 06:31:32.637915+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T06:31:33.000Z", "contentLength": 0, "httpStatusCode": 200}	867c74bd-3b89-4035-ad46-753619106210	\N	{}
daf7b0f8-5888-4b6e-bd05-b6127ca7bcf1	video_bucket	67a6fb46f2db7f7028159ce6.mp4	\N	2025-02-08 06:35:51.768235+00	2025-02-08 06:35:51.768235+00	2025-02-08 06:35:51.768235+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T06:35:52.000Z", "contentLength": 0, "httpStatusCode": 200}	c91fa803-8696-4b23-bc5c-ed01433e0aa4	\N	{}
a9e46d53-0e89-41ff-99b8-cc4320cde897	video_bucket	67a7071d79cdc5d474075610.mp4	\N	2025-02-08 07:26:22.12487+00	2025-02-08 07:26:22.12487+00	2025-02-08 07:26:22.12487+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:26:23.000Z", "contentLength": 0, "httpStatusCode": 200}	08d0744e-0e99-4792-9b4b-14cef5030aba	\N	{}
3d23562b-e82e-412e-bbd9-5a69db7cda65	video_bucket	67a3171b10835513fb7454bc.mp4	\N	2025-01-31 11:03:17.787329+00	2025-02-08 07:28:36.626787+00	2025-01-31 11:03:17.787329+00	{"eTag": "\\"389b5cd5fffcc1fa18d36545e0d9c037\\"", "size": 10471489, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:28:37.000Z", "contentLength": 10471489, "httpStatusCode": 200}	926eca88-369f-4aff-89bd-7dba8e1b0c13	\N	{}
b5a43f87-3d6f-48bf-bc6f-a41e6a09c6e5	video_bucket	67a7080f79cdc5d474075611.mp4	\N	2025-02-08 07:30:23.953382+00	2025-02-08 07:30:23.953382+00	2025-02-08 07:30:23.953382+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:30:24.000Z", "contentLength": 0, "httpStatusCode": 200}	17732936-9c74-4bbe-974c-96d8a5d40edb	\N	{}
c2c4aa3b-c27f-4d01-8464-6449b6d25148	video_bucket	67a70a3ed03310ebcc90d34f.mp4	\N	2025-02-08 07:39:45.168555+00	2025-02-08 07:39:45.168555+00	2025-02-08 07:39:45.168555+00	{"eTag": "\\"5259d8445c7170a5acbcd0d5b95c65f4\\"", "size": 3632008, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:39:45.000Z", "contentLength": 3632008, "httpStatusCode": 200}	fc1f4492-e4a0-4e15-8325-59840f9872bb	\N	{}
d4935553-ad0a-45eb-a0ee-f878aad8250b	video_bucket	67a70abfff0f36f23f4a515c.mp4	\N	2025-02-08 07:41:53.942923+00	2025-02-08 07:41:53.942923+00	2025-02-08 07:41:53.942923+00	{"eTag": "\\"1885540ecfd9afba6728580268afebbb\\"", "size": 3620629, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:41:54.000Z", "contentLength": 3620629, "httpStatusCode": 200}	34aa987c-7fa6-47b4-a404-24dbb264c082	\N	{}
c5334f79-c4f3-4972-ad50-1403dd6fbbd7	video_bucket	67a70b91ff0f36f23f4a515d.mp4	\N	2025-02-08 07:45:21.822016+00	2025-02-08 07:45:21.822016+00	2025-02-08 07:45:21.822016+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:45:22.000Z", "contentLength": 0, "httpStatusCode": 200}	d3d89a49-8081-4f8b-ae8c-909d8b4f6bb7	\N	{}
56f50bae-4295-4674-8e90-469782cc7eb4	video_bucket	67a70bfeff0f36f23f4a515e.mp4	\N	2025-02-08 07:47:11.003178+00	2025-02-08 07:47:11.003178+00	2025-02-08 07:47:11.003178+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T07:47:11.000Z", "contentLength": 0, "httpStatusCode": 200}	88b09b02-d299-4c32-a169-2316c95bfdb9	\N	{}
d381153a-e334-477c-9ce0-6d05ed52dae6	video_bucket	67a728bc9b8408a4800d3832.mp4	\N	2025-02-08 09:49:57.153903+00	2025-02-08 09:49:57.153903+00	2025-02-08 09:49:57.153903+00	{"eTag": "\\"6a0a3c9b7d0f1a02a143f0d145110608-4\\"", "size": 19395873, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T09:49:57.000Z", "contentLength": 19395873, "httpStatusCode": 200}	8a42df16-b527-4034-8a2f-614b61033da4	\N	{}
2e272caa-cc78-430c-be61-9e222a2e676d	video_bucket	67a86a100c11020c65483022.mp4	\N	2025-02-09 08:41:08.778121+00	2025-02-09 08:41:08.778121+00	2025-02-09 08:41:08.778121+00	{"eTag": "\\"56e6ad600d5ebf68c0386c1f4ed36ea1-3\\"", "size": 11077604, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T08:41:09.000Z", "contentLength": 11077604, "httpStatusCode": 200}	db4e6d19-24d8-4dd4-abb3-befb32a0a116	\N	{}
a077fda1-d1f7-4864-bdbc-d5a96e2368c2	video_bucket	67a7295e2be109ed3f42aaba.mp4	\N	2025-02-08 09:52:42.618367+00	2025-02-08 09:52:42.618367+00	2025-02-08 09:52:42.618367+00	{"eTag": "\\"982cf38e98faf8c330cd2b68e9b094ce-4\\"", "size": 20155920, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T09:52:42.000Z", "contentLength": 20155920, "httpStatusCode": 200}	461ff034-b8ce-47b9-b8cb-2ba0ee2c7f42	\N	{}
47ec61f2-2ff9-4f76-aa94-d65dcbe6769b	video_bucket	67a7381fdacdfb03795ca038.mp4	\N	2025-02-08 10:55:29.009513+00	2025-02-08 10:55:29.009513+00	2025-02-08 10:55:29.009513+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T10:55:29.000Z", "contentLength": 0, "httpStatusCode": 200}	7bb42c1f-3ff8-4f81-b826-e17e1641008e	\N	{}
6b799683-248e-451b-ab51-993b28336401	video_bucket	67a74a161a852647f69af759.mp4	\N	2025-02-08 12:14:25.995616+00	2025-02-08 12:14:25.995616+00	2025-02-08 12:14:25.995616+00	{"eTag": "\\"debe74bf316df1a82a26c7fb7006adf6-4\\"", "size": 17153385, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T12:14:26.000Z", "contentLength": 17153385, "httpStatusCode": 200}	80333ea5-c5c6-414d-9be3-200d8f06aa87	\N	{}
1eff43b1-eff5-416f-845e-11479f3ed53c	video_bucket	67a7b4768942ddf3265ddafe.mp4	\N	2025-02-08 19:46:38.446839+00	2025-02-08 19:46:38.446839+00	2025-02-08 19:46:38.446839+00	{"eTag": "\\"c1ec8fb38cfaf63fa3dedf776b174bba-2\\"", "size": 8830035, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T19:46:38.000Z", "contentLength": 8830035, "httpStatusCode": 200}	20a43ae3-3aba-46e1-b95c-0f563836e9d2	\N	{}
9dd17742-f686-48ee-a738-8e6746890dba	video_bucket	67a7b4a78942ddf3265ddaff.mp4	\N	2025-02-08 19:48:37.72645+00	2025-02-08 19:48:37.72645+00	2025-02-08 19:48:37.72645+00	{"eTag": "\\"2d3c24d08efe5a5ed172f3f47202599a-3\\"", "size": 15069813, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T19:48:38.000Z", "contentLength": 15069813, "httpStatusCode": 200}	f4cbc689-5909-4048-9f32-ba25237b4882	\N	{}
189bc8ef-2edb-4b19-bc22-7ee8102992df	video_bucket	67a7b55a8942ddf3265ddb00.mp4	\N	2025-02-08 19:51:10.459274+00	2025-02-08 19:51:10.459274+00	2025-02-08 19:51:10.459274+00	{"eTag": "\\"6e1a418c5e2da7159dc5546b29c289af-4\\"", "size": 17501831, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T19:51:10.000Z", "contentLength": 17501831, "httpStatusCode": 200}	98c271c2-cb28-4d03-b40e-32e6e5b09d19	\N	{}
840b0aff-45c6-45ef-9ef0-dcde6c058a36	video_bucket	67a7b60c8942ddf3265ddb01.mp4	\N	2025-02-08 19:53:50.062972+00	2025-02-08 19:53:50.062972+00	2025-02-08 19:53:50.062972+00	{"eTag": "\\"1f9e1c6c13ccb15f358b5986f7d1ed71-4\\"", "size": 17211872, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T19:53:50.000Z", "contentLength": 17211872, "httpStatusCode": 200}	e9e25996-d1a8-49bc-bd81-f34cc408bf07	\N	{}
724fd889-d972-4881-bbad-2ddfc8ffdbc1	video_bucket	67a7b67c8942ddf3265ddb02.mp4	\N	2025-02-08 19:55:01.805338+00	2025-02-08 19:55:01.805338+00	2025-02-08 19:55:01.805338+00	{"eTag": "\\"a0725565b7259c802ef2608bb2c2452a-3\\"", "size": 10849866, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T19:55:02.000Z", "contentLength": 10849866, "httpStatusCode": 200}	68c4550b-10b5-4a7f-baa7-5ca74bc38c99	\N	{}
9d97c116-1aaf-49cf-af83-b7b80d0b14e9	video_bucket	67a7b7fc8942ddf3265ddb03.mp4	\N	2025-02-08 20:01:11.000315+00	2025-02-08 20:01:11.000315+00	2025-02-08 20:01:11.000315+00	{"eTag": "\\"dc2945f3f0b03bbae9c1118cdd64efa3-3\\"", "size": 12173326, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-08T20:01:11.000Z", "contentLength": 12173326, "httpStatusCode": 200}	f340145d-865a-44f6-b746-e3cd886115cd	\N	{}
f0e7772c-e5d6-4654-9e0a-a0f678c989f9	video_bucket	67a3193b4a9fa8de945928df.mp4	\N	2025-02-08 13:20:13.308201+00	2025-02-08 21:52:45.332224+00	2025-02-08 13:20:13.308201+00	{"eTag": "\\"9390d1c08e4e01a9d5595453bfc0ebce\\"", "size": 2931698, "mimetype": "video/mp4", "cacheControl": "max-age=3600", "lastModified": "2025-02-08T21:52:46.000Z", "contentLength": 2931698, "httpStatusCode": 200}	8523f756-f6b8-400e-a6ea-a7e0c8171944	\N	\N
6aa94b97-9d38-4a5b-86ba-87309af6c241	video_bucket	67a802d57c8d6f4aed693110.mp4	\N	2025-02-09 01:21:21.666462+00	2025-02-09 01:21:21.666462+00	2025-02-09 01:21:21.666462+00	{"eTag": "\\"ded9fc048b209f3d1a37dd46e8892c9d-4\\"", "size": 20315833, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T01:21:21.000Z", "contentLength": 20315833, "httpStatusCode": 200}	e5845ba6-e62d-4267-8a79-3ac2127475de	\N	{}
98b6e0ad-bc8b-4ffe-a6e5-779248550f86	video_bucket	67a8052e7c8d6f4aed693111.mp4	\N	2025-02-09 01:31:09.528917+00	2025-02-09 01:31:09.528917+00	2025-02-09 01:31:09.528917+00	{"eTag": "\\"5ab9525b47c5ad3a8dae4c55920068ea-4\\"", "size": 20395226, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T01:31:09.000Z", "contentLength": 20395226, "httpStatusCode": 200}	a253ab63-0669-44fa-b7f1-68ec59a546b6	\N	{}
05f454a6-6a5e-47c6-b495-451dee7d1dbc	video_bucket	67a80a29432a20e1951a472e.mp4	\N	2025-02-09 01:51:39.972392+00	2025-02-09 01:51:39.972392+00	2025-02-09 01:51:39.972392+00	{"eTag": "\\"e824066c62091e653aaa4f0fe8192c16\\"", "size": 1157780, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T01:51:40.000Z", "contentLength": 1157780, "httpStatusCode": 200}	7980b80d-3ba8-4283-8661-217a8ca91bc7	\N	{}
d9c6ccd8-7578-4e3b-b977-2d5f86a199b8	video_bucket	67a80b17432a20e1951a472f.mp4	\N	2025-02-09 01:55:55.05262+00	2025-02-09 01:55:55.05262+00	2025-02-09 01:55:55.05262+00	{"eTag": "\\"92b4e599a25440d1574ceb80c3169fb0-2\\"", "size": 8896400, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T01:55:55.000Z", "contentLength": 8896400, "httpStatusCode": 200}	13f656a5-e4a6-48bc-bd35-a40bd423f42f	\N	{}
60a52d98-3981-4ebe-9bac-5a22f357fec7	video_bucket	67a837f5656a65b77d5c88a5.mp4	\N	2025-02-09 05:08:31.402211+00	2025-02-09 05:08:31.402211+00	2025-02-09 05:08:31.402211+00	{"eTag": "\\"0b850fb6ab3819a224dff60852e2af8b-5\\"", "size": 22587656, "mimetype": "text/plain", "cacheControl": "no-cache", "lastModified": "2025-02-09T05:08:31.000Z", "contentLength": 22587656, "httpStatusCode": 200}	ba7f00d1-9f2d-4c75-a32c-f6bff03d2622	\N	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2025-01-22 19:13:52.601363+00
20210809183423_update_grants	2025-01-22 19:13:52.601363+00
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: jobid_seq; Type: SEQUENCE SET; Schema: cron; Owner: supabase_admin
--

SELECT pg_catalog.setval('cron.jobid_seq', 1, true);


--
-- Name: runid_seq; Type: SEQUENCE SET; Schema: cron; Owner: supabase_admin
--

SELECT pg_catalog.setval('cron.runid_seq', 16, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: current_location_userID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."current_location_userID_seq"', 1, false);


--
-- Name: friend_relations_userID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."friend_relations_userID_seq"', 1, false);


--
-- Name: inapp_notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inapp_notifications_notification_id_seq', 1820, true);


--
-- Name: incident_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_reports_id_seq', 10, true);


--
-- Name: incident_sub_types_typeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."incident_sub_types_typeID_seq"', 1, false);


--
-- Name: incident_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_types_id_seq', 4, true);


--
-- Name: message_services_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_services_service_id_seq', 1, false);


--
-- Name: notification_types_notification_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_types_notification_type_id_seq', 1, false);


--
-- Name: pending_friend_relations_senderID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."pending_friend_relations_senderID_seq"', 1, false);


--
-- Name: poke_user_requests_sender_poker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poke_user_requests_sender_poker_id_seq', 1, false);


--
-- Name: travel_locations__userID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."travel_locations__userID_seq"', 1, false);


--
-- Name: travel_locations_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.travel_locations_location_id_seq', 30, true);


--
-- Name: travel_mode_details_userID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."travel_mode_details_userID_seq"', 1, false);


--
-- Name: user_notification_preferences_userID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."user_notification_preferences_userID_seq"', 1, false);


--
-- Name: users_userID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."users_userID_seq"', 49, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: api_service_config api_service_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_service_config
    ADD CONSTRAINT api_service_config_pkey PRIMARY KEY (service_name);


--
-- Name: button_user_config button_user_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.button_user_config
    ADD CONSTRAINT button_user_config_pkey PRIMARY KEY (button_mac);


--
-- Name: current_location current_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_location
    ADD CONSTRAINT current_location_pkey PRIMARY KEY ("userID");


--
-- Name: friend_relations friend_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friend_relations
    ADD CONSTRAINT friend_relations_pkey PRIMARY KEY ("userID", "friendID");


--
-- Name: inapp_notifications inapp_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inapp_notifications
    ADD CONSTRAINT inapp_notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: incident_reports incident_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_reports
    ADD CONSTRAINT incident_reports_pkey PRIMARY KEY (id);


--
-- Name: incident_sub_types incident_sub_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_sub_types
    ADD CONSTRAINT incident_sub_types_pkey PRIMARY KEY ("subtypeID");


--
-- Name: incident_types incident_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_pkey PRIMARY KEY ("typeID");


--
-- Name: message_services message_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_services
    ADD CONSTRAINT message_services_pkey PRIMARY KEY (service_id);


--
-- Name: message_services message_services_service_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_services
    ADD CONSTRAINT message_services_service_name_key UNIQUE (service_name);


--
-- Name: notification_types notification_types_notification_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_types
    ADD CONSTRAINT notification_types_notification_name_key UNIQUE (notification_name);


--
-- Name: notification_types notification_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_types
    ADD CONSTRAINT notification_types_pkey PRIMARY KEY (notification_type_id);


--
-- Name: pending_friend_relations pending_friend_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_friend_relations
    ADD CONSTRAINT pending_friend_relations_pkey PRIMARY KEY ("senderID", "receiverID");


--
-- Name: poker_user_requests poke_user_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poker_user_requests
    ADD CONSTRAINT poke_user_requests_pkey PRIMARY KEY (sender_poker_id, receiver_poker_id);


--
-- Name: travel_locations travel_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_locations
    ADD CONSTRAINT travel_locations_pkey PRIMARY KEY (location_id);


--
-- Name: travel_mode_details travel_mode_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_mode_details
    ADD CONSTRAINT travel_mode_details_pkey PRIMARY KEY ("userID");


--
-- Name: user_notification_preferences user_notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_pkey PRIMARY KEY ("userID", notification_type_id, service_id);


--
-- Name: users users_aadhar_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_aadhar_no_key UNIQUE (aadhar_no);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_no_key UNIQUE (phone_no);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY ("userID");


--
-- Name: verification_codes verification_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_codes
    ADD CONSTRAINT verification_codes_pkey PRIMARY KEY (email);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: users after_user_insert_update_notification_preferences; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_user_insert_update_notification_preferences AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.populate_user_preferences();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: current_location current_location_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_location
    ADD CONSTRAINT "current_location_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: friend_relations friend_relations_friendID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friend_relations
    ADD CONSTRAINT "friend_relations_friendID_fkey" FOREIGN KEY ("friendID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: friend_relations friend_relations_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.friend_relations
    ADD CONSTRAINT "friend_relations_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inapp_notifications inapp_notifications_notification_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inapp_notifications
    ADD CONSTRAINT inapp_notifications_notification_type_id_fkey FOREIGN KEY (notification_type_id) REFERENCES public.notification_types(notification_type_id);


--
-- Name: inapp_notifications inapp_notifications_notifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inapp_notifications
    ADD CONSTRAINT inapp_notifications_notifier_id_fkey FOREIGN KEY (notifier_id) REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: incident_reports incident_reports_subtypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_reports
    ADD CONSTRAINT "incident_reports_subtypeID_fkey" FOREIGN KEY ("subtypeID") REFERENCES public.incident_sub_types("subtypeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: incident_reports incident_reports_typeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_reports
    ADD CONSTRAINT "incident_reports_typeID_fkey" FOREIGN KEY ("typeID") REFERENCES public.incident_types("typeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: incident_reports incident_reports_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_reports
    ADD CONSTRAINT "incident_reports_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: incident_sub_types incident_sub_types_typeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_sub_types
    ADD CONSTRAINT "incident_sub_types_typeID_fkey" FOREIGN KEY ("typeID") REFERENCES public.incident_types("typeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pending_friend_relations pending_friend_relations_receiverID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_friend_relations
    ADD CONSTRAINT "pending_friend_relations_receiverID_fkey" FOREIGN KEY ("receiverID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pending_friend_relations pending_friend_relations_senderID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pending_friend_relations
    ADD CONSTRAINT "pending_friend_relations_senderID_fkey" FOREIGN KEY ("senderID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: poker_user_requests poke_user_requests_receiver_poker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poker_user_requests
    ADD CONSTRAINT poke_user_requests_receiver_poker_id_fkey FOREIGN KEY (receiver_poker_id) REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: poker_user_requests poke_user_requests_sender_poker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poker_user_requests
    ADD CONSTRAINT poke_user_requests_sender_poker_id_fkey FOREIGN KEY (sender_poker_id) REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: travel_locations travel_locations__userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_locations
    ADD CONSTRAINT "travel_locations__userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: travel_mode_details travel_mode_details_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.travel_mode_details
    ADD CONSTRAINT "travel_mode_details_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_notification_preferences user_notification_preferences_notification_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_notification_type_id_fkey FOREIGN KEY (notification_type_id) REFERENCES public.notification_types(notification_type_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_notification_preferences user_notification_preferences_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.message_services(service_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_notification_preferences user_notification_preferences_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_notification_preferences
    ADD CONSTRAINT "user_notification_preferences_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users("userID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA cron; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA cron TO postgres WITH GRANT OPTION;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION alter_job(job_id bigint, schedule text, command text, database text, username text, active boolean); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.alter_job(job_id bigint, schedule text, command text, database text, username text, active boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION job_cache_invalidate(); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.job_cache_invalidate() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule(schedule text, command text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule(schedule text, command text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule(job_name text, schedule text, command text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule(job_name text, schedule text, command text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule_in_database(job_name text, schedule text, command text, database text, username text, active boolean); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule_in_database(job_name text, schedule text, command text, database text, username text, active boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION unschedule(job_id bigint); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.unschedule(job_id bigint) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION unschedule(job_name text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.unschedule(job_name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) FROM postgres;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) FROM postgres;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.try_cast_double(inp text) FROM postgres;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.url_decode(data text) FROM postgres;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.url_encode(data bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) FROM postgres;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION delete_non_sos_notifications(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.delete_non_sos_notifications() TO anon;
GRANT ALL ON FUNCTION public.delete_non_sos_notifications() TO authenticated;
GRANT ALL ON FUNCTION public.delete_non_sos_notifications() TO service_role;


--
-- Name: FUNCTION populate_user_preferences(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.populate_user_preferences() TO anon;
GRANT ALL ON FUNCTION public.populate_user_preferences() TO authenticated;
GRANT ALL ON FUNCTION public.populate_user_preferences() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.schema_migrations TO postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE job; Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT SELECT ON TABLE cron.job TO postgres WITH GRANT OPTION;


--
-- Name: TABLE job_run_details; Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON TABLE cron.job_run_details TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE api_service_config; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.api_service_config TO anon;
GRANT ALL ON TABLE public.api_service_config TO authenticated;
GRANT ALL ON TABLE public.api_service_config TO service_role;


--
-- Name: TABLE button_user_config; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.button_user_config TO anon;
GRANT ALL ON TABLE public.button_user_config TO authenticated;
GRANT ALL ON TABLE public.button_user_config TO service_role;


--
-- Name: TABLE current_location; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.current_location TO anon;
GRANT ALL ON TABLE public.current_location TO authenticated;
GRANT ALL ON TABLE public.current_location TO service_role;


--
-- Name: SEQUENCE "current_location_userID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."current_location_userID_seq" TO anon;
GRANT ALL ON SEQUENCE public."current_location_userID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."current_location_userID_seq" TO service_role;


--
-- Name: TABLE friend_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.friend_relations TO anon;
GRANT ALL ON TABLE public.friend_relations TO authenticated;
GRANT ALL ON TABLE public.friend_relations TO service_role;


--
-- Name: SEQUENCE "friend_relations_userID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."friend_relations_userID_seq" TO anon;
GRANT ALL ON SEQUENCE public."friend_relations_userID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."friend_relations_userID_seq" TO service_role;


--
-- Name: TABLE inapp_notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inapp_notifications TO anon;
GRANT ALL ON TABLE public.inapp_notifications TO authenticated;
GRANT ALL ON TABLE public.inapp_notifications TO service_role;


--
-- Name: SEQUENCE inapp_notifications_notification_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inapp_notifications_notification_id_seq TO anon;
GRANT ALL ON SEQUENCE public.inapp_notifications_notification_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inapp_notifications_notification_id_seq TO service_role;


--
-- Name: TABLE incident_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.incident_reports TO anon;
GRANT ALL ON TABLE public.incident_reports TO authenticated;
GRANT ALL ON TABLE public.incident_reports TO service_role;


--
-- Name: SEQUENCE incident_reports_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.incident_reports_id_seq TO anon;
GRANT ALL ON SEQUENCE public.incident_reports_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.incident_reports_id_seq TO service_role;


--
-- Name: TABLE incident_sub_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.incident_sub_types TO anon;
GRANT ALL ON TABLE public.incident_sub_types TO authenticated;
GRANT ALL ON TABLE public.incident_sub_types TO service_role;


--
-- Name: SEQUENCE "incident_sub_types_typeID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."incident_sub_types_typeID_seq" TO anon;
GRANT ALL ON SEQUENCE public."incident_sub_types_typeID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."incident_sub_types_typeID_seq" TO service_role;


--
-- Name: TABLE incident_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.incident_types TO anon;
GRANT ALL ON TABLE public.incident_types TO authenticated;
GRANT ALL ON TABLE public.incident_types TO service_role;


--
-- Name: SEQUENCE incident_types_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.incident_types_id_seq TO anon;
GRANT ALL ON SEQUENCE public.incident_types_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.incident_types_id_seq TO service_role;


--
-- Name: TABLE message_services; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.message_services TO anon;
GRANT ALL ON TABLE public.message_services TO authenticated;
GRANT ALL ON TABLE public.message_services TO service_role;


--
-- Name: SEQUENCE message_services_service_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.message_services_service_id_seq TO anon;
GRANT ALL ON SEQUENCE public.message_services_service_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.message_services_service_id_seq TO service_role;


--
-- Name: TABLE notification_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notification_types TO anon;
GRANT ALL ON TABLE public.notification_types TO authenticated;
GRANT ALL ON TABLE public.notification_types TO service_role;


--
-- Name: SEQUENCE notification_types_notification_type_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.notification_types_notification_type_id_seq TO anon;
GRANT ALL ON SEQUENCE public.notification_types_notification_type_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.notification_types_notification_type_id_seq TO service_role;


--
-- Name: TABLE pending_friend_relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pending_friend_relations TO anon;
GRANT ALL ON TABLE public.pending_friend_relations TO authenticated;
GRANT ALL ON TABLE public.pending_friend_relations TO service_role;


--
-- Name: SEQUENCE "pending_friend_relations_senderID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."pending_friend_relations_senderID_seq" TO anon;
GRANT ALL ON SEQUENCE public."pending_friend_relations_senderID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."pending_friend_relations_senderID_seq" TO service_role;


--
-- Name: TABLE poker_user_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.poker_user_requests TO anon;
GRANT ALL ON TABLE public.poker_user_requests TO authenticated;
GRANT ALL ON TABLE public.poker_user_requests TO service_role;


--
-- Name: SEQUENCE poke_user_requests_sender_poker_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.poke_user_requests_sender_poker_id_seq TO anon;
GRANT ALL ON SEQUENCE public.poke_user_requests_sender_poker_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.poke_user_requests_sender_poker_id_seq TO service_role;


--
-- Name: TABLE travel_locations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.travel_locations TO anon;
GRANT ALL ON TABLE public.travel_locations TO authenticated;
GRANT ALL ON TABLE public.travel_locations TO service_role;


--
-- Name: SEQUENCE "travel_locations__userID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."travel_locations__userID_seq" TO anon;
GRANT ALL ON SEQUENCE public."travel_locations__userID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."travel_locations__userID_seq" TO service_role;


--
-- Name: SEQUENCE travel_locations_location_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.travel_locations_location_id_seq TO anon;
GRANT ALL ON SEQUENCE public.travel_locations_location_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.travel_locations_location_id_seq TO service_role;


--
-- Name: TABLE travel_mode_details; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.travel_mode_details TO anon;
GRANT ALL ON TABLE public.travel_mode_details TO authenticated;
GRANT ALL ON TABLE public.travel_mode_details TO service_role;


--
-- Name: SEQUENCE "travel_mode_details_userID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."travel_mode_details_userID_seq" TO anon;
GRANT ALL ON SEQUENCE public."travel_mode_details_userID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."travel_mode_details_userID_seq" TO service_role;


--
-- Name: TABLE user_notification_preferences; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_notification_preferences TO anon;
GRANT ALL ON TABLE public.user_notification_preferences TO authenticated;
GRANT ALL ON TABLE public.user_notification_preferences TO service_role;


--
-- Name: SEQUENCE "user_notification_preferences_userID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."user_notification_preferences_userID_seq" TO anon;
GRANT ALL ON SEQUENCE public."user_notification_preferences_userID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."user_notification_preferences_userID_seq" TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: SEQUENCE "users_userID_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."users_userID_seq" TO anon;
GRANT ALL ON SEQUENCE public."users_userID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."users_userID_seq" TO service_role;


--
-- Name: TABLE verification_codes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.verification_codes TO anon;
GRANT ALL ON TABLE public.verification_codes TO authenticated;
GRANT ALL ON TABLE public.verification_codes TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

