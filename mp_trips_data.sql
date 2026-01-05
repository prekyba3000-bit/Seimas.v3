-- MP Business Trips Data Import
-- This script matches MP names to IDs and inserts their business trips

DO $$
BEGIN

-- Sample data for business trips (I will provide more in the final delivery)
INSERT INTO mp_trips (mp_id, destination, purpose, start_date, end_date, cost)
SELECT id, 'Briuselis, Belgija', 'Dalyvavimas Europos Parlamento posėdyje', '2025-11-10 09:00:00', '2025-11-12 18:00:00', 1250.50 FROM mps WHERE name = 'Šimonytė Ingrida';

INSERT INTO mp_trips (mp_id, destination, purpose, start_date, end_date, cost)
SELECT id, 'Vašingtonas, JAV', 'Susitikimas su JAV Kongreso nariais', '2025-10-05 08:00:00', '2025-10-10 20:00:00', 3450.00 FROM mps WHERE name = 'Pavilionis Žygimantas';

INSERT INTO mp_trips (mp_id, destination, purpose, start_date, end_date, cost)
SELECT id, 'Kijevas, Ukraina', 'Paramos Ukrainai koordinavimas', '2025-12-01 07:00:00', '2025-12-03 22:00:00', 850.00 FROM mps WHERE name = 'Kasčiūnas Laurynas';

END $$;
