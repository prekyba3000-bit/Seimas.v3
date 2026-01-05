-- MP Assistants Data Import
-- This script matches MP names to IDs and inserts their assistants

DO $$
BEGIN

-- Alekna Virgilijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dalia KUZNECOVIENĖ', 'Patarėja', '(0 5) 239 6616', 'dalia.kuznecoviene@lrs.lt' FROM mps WHERE name = 'Alekna Virgilijus';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6616', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Alekna Virgilijus';

-- Aleknavičienė Vaida
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Darius BRAZYS', 'Patarėjas', '(0 5) 239 6656', 'darius.brazys@lrs.lt' FROM mps WHERE name = 'Aleknavičienė Vaida';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6656', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Aleknavičienė Vaida';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6656', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Aleknavičienė Vaida';

-- Anušauskas Arvydas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6652', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Anušauskas Arvydas';

-- Asadauskaitė-Zadneprovskienė Laura
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gedeminas ALEKSONIS', 'Patarėjas', '(0 5) 239 6625', 'gedeminas.aleksonis@lrs.lt' FROM mps WHERE name = 'Asadauskaitė-Zadneprovskienė Laura';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6625', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Asadauskaitė-Zadneprovskienė Laura';

-- Asanavičiūtė-Gružauskienė Dalia
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Giedrė ČEKAVIČIENĖ', 'Patarėja', '(0 5) 239 6699', 'giedre.cekaviciene@lrs.lt' FROM mps WHERE name = 'Asanavičiūtė-Gružauskienė Dalia';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Aistė ČIURLIONYTĖ', 'Patarėja', '(0 5) 239 6699', 'aiste.ciurlionyte@lrs.lt' FROM mps WHERE name = 'Asanavičiūtė-Gružauskienė Dalia';

-- Ažubalis Audronius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Eglė ČIČIŪNAITĖ', 'Patarėja', '(0 5) 239 6628', 'egle.ciciunaite@lrs.lt' FROM mps WHERE name = 'Ažubalis Audronius';

-- Ąžuolas Valius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Eglė KANČAUSKIENĖ', 'Patarėja', '(0 5) 239 6615', 'egle.kancauskiene@lrs.lt' FROM mps WHERE name = 'Ąžuolas Valius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Reda ŠIAULIENĖ', 'Patarėja', '(0 5) 239 6615', 'reda.siauliene@lrs.lt' FROM mps WHERE name = 'Ąžuolas Valius';

-- Bagdonas Andrius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6600', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Bagdonas Andrius';

-- Balčytis Zigmantas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Vaidutė JAKŠTONIENĖ', 'Patarėja', '(0 5) 209 6736', 'vaidute.jakstoniene@lrs.lt' FROM mps WHERE name = 'Balčytis Zigmantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Vytautas LAMAUSKAS', 'Patarėjas', '(0 5) 209 6736', 'vytautas.lamauskas@lrs.lt' FROM mps WHERE name = 'Balčytis Zigmantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Arūnas PUPŠYS', 'Patarėjas', '(0 5) 209 6736', 'arunas.pupsys@lrs.lt' FROM mps WHERE name = 'Balčytis Zigmantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Liutauras VIČKAČKA', 'Patarėjas', '(0 5) 209 6736', 'liutauras.vickacka@lrs.lt' FROM mps WHERE name = 'Balčytis Zigmantas';

-- Balčytytė Giedrė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6640', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Balčytytė Giedrė';

-- Balsys Linas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6668', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Balsys Linas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6668', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Balsys Linas';

-- Baranovas Ruslanas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6705', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Baranovas Ruslanas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6705', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Baranovas Ruslanas';

-- Barauskas Tadas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6648', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Barauskas Tadas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6648', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Barauskas Tadas';

-- Baškienė Rima
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6656', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Baškienė Rima';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6656', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Baškienė Rima';

-- Bilius Kęstutis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6654', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Bilius Kęstutis';

-- Bilotaitė Agnė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6682', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Bilotaitė Agnė';

-- Birutis Šarūnas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6669', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Birutis Šarūnas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6669', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Birutis Šarūnas';

-- Bradauskas Dainoras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6641', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Bradauskas Dainoras';

-- Braziulienė Ingrida
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6642', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Braziulienė Ingrida';

-- Bucevičius Saulius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6656', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Bucevičius Saulius';

-- Budbergytė Rasa
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6663', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Budbergytė Rasa';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6663', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Budbergytė Rasa';

-- Busila Andrius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6645', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Busila Andrius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6645', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Busila Andrius';

-- Butkevičius Algirdas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6683', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Butkevičius Algirdas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6683', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Butkevičius Algirdas';

-- Čaplinskas Saulius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6686', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Čaplinskas Saulius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6686', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Čaplinskas Saulius';

-- Čmilytė-Nielsen Viktorija
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6601', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Čmilytė-Nielsen Viktorija';

-- Dargis Petras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6651', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Dargis Petras';

-- Domarkas Tomas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6656', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Domarkas Tomas';

-- Drukteinis Giedrius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6706', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Drukteinis Giedrius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6706', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Drukteinis Giedrius';

-- Dudėnas Arūnas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6673', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Dudėnas Arūnas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6673', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Dudėnas Arūnas';

-- Fiodorovas Viktoras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6674', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Fiodorovas Viktoras';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6674', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Fiodorovas Viktoras';

-- Gailius Vitalijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6607', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Gailius Vitalijus';

-- Gaižauskas Dainius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Eglė KANČAUSKIENĖ', 'Patarėja', '(0 5) 239 6615', 'egle.kancauskiene@lrs.lt' FROM mps WHERE name = 'Gaižauskas Dainius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Reda ŠIAULIENĖ', 'Patarėja', '(0 5) 239 6615', 'reda.siauliene@lrs.lt' FROM mps WHERE name = 'Gaižauskas Dainius';

-- Gedvilas Aidas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6653', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Gedvilas Aidas';

-- Gedvilas Martynas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6650', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Gedvilas Martynas';

-- Gedvilienė Aistė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6687', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Gedvilienė Aistė';

-- Gentvilas Eugenijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6603', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Gentvilas Eugenijus';

-- Gentvilas Simonas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6603', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Gentvilas Simonas';

-- Grubliauskas Vytautas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6671', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Grubliauskas Vytautas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6671', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Grubliauskas Vytautas';

-- Jakavičiūtė-Miliauskienė Agnė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6613', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Jakavičiūtė-Miliauskienė Agnė';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6613', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Jakavičiūtė-Miliauskienė Agnė';

-- Jakavičius Darius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6649', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Jakavičius Darius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6649', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Jakavičius Darius';

-- Janušonienė Roma
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6655', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Janušonienė Roma';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6655', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Janušonienė Roma';

-- Jeglinskas Giedrimas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6684', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Jeglinskas Giedrimas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6684', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Jeglinskas Giedrimas';

-- Jonauskas Linas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6672', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Jonauskas Linas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6672', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Jonauskas Linas';

-- Jucius Vytautas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6648', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Jucius Vytautas';

-- Juozapaitis Vytautas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6670', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Juozapaitis Vytautas';

-- Juška Ričardas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6685', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Juška Ričardas';

-- Kairys Simonas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6604', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Kairys Simonas';

-- Kasčiūnas Laurynas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6681', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Kasčiūnas Laurynas';

-- Katelynas Martynas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6658', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Katelynas Martynas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6658', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Katelynas Martynas';

-- Kaunas Robertas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6659', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Kaunas Robertas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6659', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Kaunas Robertas';

-- Kazlavickas Liutauras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6644', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Kazlavickas Liutauras';

-- Kernagis Vytautas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6634', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Kernagis Vytautas';

-- Kirkutis Eimantas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6650', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Kirkutis Eimantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6650', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Kirkutis Eimantas';

-- Kižienė Indrė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6651', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Kižienė Indrė';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6651', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Kižienė Indrė';

-- Kreivys Dainius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6637', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Kreivys Dainius';

-- Kukuraitis Linas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6679', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Kukuraitis Linas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6679', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Kukuraitis Linas';

-- Kuodis Raimondas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6675', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Kuodis Raimondas';

-- Kuzmickienė Paulė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6632', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Kuzmickienė Paulė';

-- Leiputė Orinta
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6677', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Leiputė Orinta';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6677', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Leiputė Orinta';

-- Lydeka Arminas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6690', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Lydeka Arminas';

-- Lingė Mindaugas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6631', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Lingė Mindaugas';

-- Luščikas Saulius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6656', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Luščikas Saulius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6656', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Luščikas Saulius';

-- Maldeikis Matas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6633', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Maldeikis Matas';

-- Martinaitis Tomas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6658', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Martinaitis Tomas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6658', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Martinaitis Tomas';

-- Mažeika Kęstutis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6680', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Mažeika Kęstutis';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6680', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Mažeika Kęstutis';

-- Miliūtė Rūta
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6660', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Miliūtė Rūta';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6660', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Miliūtė Rūta';

-- Mockus Alvydas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6646', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Mockus Alvydas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6646', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Mockus Alvydas';

-- Morkūnaitė-Mikulėnienė Radvilė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6678', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Morkūnaitė-Mikulėnienė Radvilė';

-- Motuzas Remigijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6644', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Motuzas Remigijus';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6644', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Motuzas Remigijus';

-- Narkevič Jaroslav
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6652', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Narkevič Jaroslav';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6652', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Narkevič Jaroslav';

-- Nedzinskas Antanas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6676', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Nedzinskas Antanas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6676', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Nedzinskas Antanas';

-- Neimantas Karolis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6652', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Neimantas Karolis';

-- Norkienė Aušrinė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Eglė KANČAUSKIENĖ', 'Patarėja', '(0 5) 239 6681', 'egle.kancauskiene@lrs.lt' FROM mps WHERE name = 'Norkienė Aušrinė';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Reda ŠIAULIENĖ', 'Patarėja', '(0 5) 239 6681', 'reda.siauliene@lrs.lt' FROM mps WHERE name = 'Norkienė Aušrinė';

-- Olekas Juozas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6671', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Olekas Juozas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6671', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Olekas Juozas';

-- Olševski Česlav
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6678', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Olševski Česlav';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6678', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Olševski Česlav';

-- Paluckas Gintautas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6679', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Paluckas Gintautas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6679', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Paluckas Gintautas';

-- Pavilionis Žygimantas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6636', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Pavilionis Žygimantas';

-- Petkevičienė Daiva
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6647', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Petkevičienė Daiva';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6647', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Petkevičienė Daiva';

-- Petrauskaitė Modesta
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6660', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Petrauskaitė Modesta';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6660', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Petrauskaitė Modesta';

-- Petrošius Audrius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6638', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Petrošius Audrius';

-- Pocius Arvydas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6677', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Pocius Arvydas';

-- Podolskis Karolis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6707', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Podolskis Karolis';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6707', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Podolskis Karolis';

-- Popovienė Raminta
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6662', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Popovienė Raminta';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6662', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Popovienė Raminta';

-- Poškus Mantas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6653', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Poškus Mantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6653', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Poškus Mantas';

-- Prajara Tadas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6657', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Prajara Tadas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6657', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Prajara Tadas';

-- Pranckietis Viktoras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6602', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Pranckietis Viktoras';

-- Puchovič Robert
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6649', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Puchovič Robert';

-- Radvila Algimantas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6645', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Radvila Algimantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6645', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Radvila Algimantas';

-- Radvilavičius Audrius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6646', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Radvilavičius Audrius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6646', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Radvilavičius Audrius';

-- Rakutis Valdas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6635', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Rakutis Valdas';

-- Razma Jurgis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6676', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Razma Jurgis';

-- Razmislevičius Darius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6708', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Razmislevičius Darius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6708', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Razmislevičius Darius';

-- Rojaka Jekaterina
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6684', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Rojaka Jekaterina';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6684', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Rojaka Jekaterina';

-- Ropė Bronis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Eglė KANČAUSKIENĖ', 'Patarėja', '(0 5) 239 6678', 'egle.kancauskiene@lrs.lt' FROM mps WHERE name = 'Ropė Bronis';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Reda ŠIAULIENĖ', 'Patarėja', '(0 5) 239 6678', 'reda.siauliene@lrs.lt' FROM mps WHERE name = 'Ropė Bronis';

-- Rudelienė Edita
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Gintarė ŽEMAITYTĖ', 'Patarėja', '(0 5) 239 6606', 'gintare.zemaityte@lrs.lt' FROM mps WHERE name = 'Rudelienė Edita';

-- Ruginienė Inga
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6661', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Ruginienė Inga';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6661', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Ruginienė Inga';

-- Sabatauskas Julius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6678', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Sabatauskas Julius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6678', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Sabatauskas Julius';

-- Sabutis Eugenijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6682', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Sabutis Eugenijus';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6682', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Sabutis Eugenijus';

-- Sadauskis Tadas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6653', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Sadauskis Tadas';

-- Savickas Lukas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6680', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Savickas Lukas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6680', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Savickas Lukas';

-- Sejonienė Jurgita
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6639', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Sejonienė Jurgita';

-- Sinica Vytautas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6706', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Sinica Vytautas';

-- Sinkevičius Rimantas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6683', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Sinkevičius Rimantas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6683', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Sinkevičius Rimantas';

-- Sysas Algirdas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6674', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Sysas Algirdas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6674', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Sysas Algirdas';

-- Skaistė Gintarė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6635', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Skaistė Gintarė';

-- Skamarakas Matas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6663', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Skamarakas Matas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6663', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Skamarakas Matas';

-- Skardžius Artūras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6686', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Skardžius Artūras';

-- Skvernelis Saulius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6677', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Skvernelis Saulius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6677', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Skvernelis Saulius';

-- Starkevičius Kazys
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6691', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Starkevičius Kazys';

-- Šakalienė Dovilė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6634', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Šakalienė Dovilė';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6634', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Šakalienė Dovilė';

-- Šedvydis Laurynas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6614', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Šedvydis Laurynas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6614', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Šedvydis Laurynas';

-- Šeršniovas Vitalijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6660', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Šeršniovas Vitalijus';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6660', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Šeršniovas Vitalijus';

-- Šimonytė Ingrida
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6676', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Šimonytė Ingrida';

-- Širinskienė Agnė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6681', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Širinskienė Agnė';

-- Šukevičienė Jurgita
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6659', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Šukevičienė Jurgita';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6659', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Šukevičienė Jurgita';

-- Šukevičius Šarūnas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6660', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Šukevičius Šarūnas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6660', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Šukevičius Šarūnas';

-- Šukys Raimondas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6681', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Šukys Raimondas';

-- Šukytė-Korsakė Lina
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6682', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Šukytė-Korsakė Lina';

-- Šuklin Jevgenij
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6683', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Šuklin Jevgenij';

-- Tamašunienė Rita
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6691', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Tamašunienė Rita';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6691', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Tamašunienė Rita';

-- Tomilinas Tomas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Ada GRAKAUSKIENĖ', 'Patarėja', '(0 5) 239 6681', 'ada.grakauskiene@lrs.lt' FROM mps WHERE name = 'Tomilinas Tomas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Judita ŠAKOČIUVIENĖ', 'Patarėja', '(0 5) 239 6681', 'judita.sakociuviene@lrs.lt' FROM mps WHERE name = 'Tomilinas Tomas';

-- Turauskaitė Violeta
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6659', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Turauskaitė Violeta';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6659', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Turauskaitė Violeta';

-- Ulbinaitė Daiva
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6660', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Ulbinaitė Daiva';

-- Urmanavičius Linas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6661', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Urmanavičius Linas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6661', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Urmanavičius Linas';

-- Vaitiekūnienė Lilija
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6662', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Vaitiekūnienė Lilija';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6662', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Vaitiekūnienė Lilija';

-- Valinskas Arūnas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6663', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Valinskas Arūnas';

-- Varnas Dainius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6651', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Varnas Dainius';

-- Vėgėlė Ignas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6682', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Vėgėlė Ignas';

-- Vėsaitė Birutė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Eglė KANČAUSKIENĖ', 'Patarėja', '(0 5) 239 6679', 'egle.kancauskiene@lrs.lt' FROM mps WHERE name = 'Vėsaitė Birutė';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Reda ŠIAULIENĖ', 'Patarėja', '(0 5) 239 6679', 'reda.siauliene@lrs.lt' FROM mps WHERE name = 'Vėsaitė Birutė';

-- Vilkauskas Kęstutis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6680', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Vilkauskas Kęstutis';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6680', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Vilkauskas Kęstutis';

-- Visockas Paulius
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6681', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Visockas Paulius';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6681', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Visockas Paulius';

-- Vyžintas Ramūnas
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6682', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Vyžintas Ramūnas';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6682', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Vyžintas Ramūnas';

-- Zailskienė Jūratė
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6683', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Zailskienė Jūratė';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6683', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Zailskienė Jūratė';

-- Zingeris Emanuelis
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Greta LABENSKAITĖ', 'Patarėja', '(0 5) 239 6684', 'greta.labenskaite@lrs.lt' FROM mps WHERE name = 'Zingeris Emanuelis';

-- Zuokas Artūras
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6685', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Zuokas Artūras';

-- Žebelienė Daiva
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Erika KIŽIENĖ', 'Patarėja', '(0 5) 239 6686', 'erika.kiziene@lrs.lt' FROM mps WHERE name = 'Žebelienė Daiva';
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Linas ŠALNA', 'Patarėjas', '(0 5) 239 6686', 'linas.salna@lrs.lt' FROM mps WHERE name = 'Žebelienė Daiva';

-- Žemaitaitis Remigijus
INSERT INTO mp_assistants (mp_id, name, role, phone, email)
SELECT id, 'Dovilė ŠALAVĖJIENĖ', 'Patarėja', '(0 5) 239 6687', 'dovile.salavejiene@lrs.lt' FROM mps WHERE name = 'Žemaitaitis Remigijus';

END $$;
