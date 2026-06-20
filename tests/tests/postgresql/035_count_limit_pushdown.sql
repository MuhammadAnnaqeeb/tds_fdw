DO $$
DECLARE
    line text;
    explain_text text := '';
BEGIN
    FOR line IN EXECUTE 'EXPLAIN (VERBOSE) SELECT COUNT(*) FROM @PSCHEMANAME.view_simple' LOOP
        explain_text := explain_text || line || E'\n';
    END LOOP;

    IF position('COUNT(*)' in explain_text) = 0
       AND position('COUNT(' in explain_text) = 0 THEN
        RAISE EXCEPTION 'COUNT(*) was not pushed down: %', explain_text;
    END IF;

    explain_text := '';
    FOR line IN EXECUTE 'EXPLAIN (VERBOSE) SELECT * FROM @PSCHEMANAME.view_simple LIMIT 2' LOOP
        explain_text := explain_text || line || E'\n';
    END LOOP;

    IF position('TOP 2' in explain_text) = 0
       AND position('FETCH NEXT 2 ROWS ONLY' in explain_text) = 0 THEN
        RAISE EXCEPTION 'LIMIT was not pushed down: %', explain_text;
    END IF;
END
$$;
