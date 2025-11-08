DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT schemaname, tablename, policyname FROM pg_policies LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I;', r.policyname, r.schemaname, r.tablename);
  END LOOP;
END;
$$;
