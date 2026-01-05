import { drizzle } from 'drizzle-orm/mysql2';
import { mps, bills, votes, mpStats, quizQuestions, quizAnswers } from '../drizzle/schema';
import dotenv from 'dotenv';

dotenv.config();

const db = drizzle(process.env.DATABASE_URL!);

// Sample Lithuanian parties
const parties = [
  'Tėvynės sąjunga-Lietuvos krikščionys demokratai',
  'Lietuvos valstiečių ir žaliųjų sąjunga',
  'Lietuvos socialdemokratų partija',
  'Liberalų sąjūdis',
  'Darbo partija',
  'Laisvės partija',
  'Demokratų sąjunga „Vardan Lietuvos"',
];

// Sample MP names (mix of common Lithuanian names)
const firstNames = ['Jonas', 'Petras', 'Antanas', 'Mindaugas', 'Vytautas', 'Rasa', 'Ingrida', 'Gintarė', 'Dalia', 'Agnė'];
const lastNames = ['Kazlauskas', 'Petrauskas', 'Jankauskas', 'Vasiliauskas', 'Šimonytė', 'Nausėda', 'Skvernelis', 'Butkevičius'];

function generateMpName() {
  const first = firstNames[Math.floor(Math.random() * firstNames.length)];
  const last = lastNames[Math.floor(Math.random() * lastNames.length)];
  return `${first} ${last}`;
}

function generateDistrict() {
  const districts = [
    'Antakalnio', 'Naujamiesčio', 'Senamiesčio', 'Žirmūnų', 'Karoliniškių',
    'Kauno', 'Klaipėdos', 'Šiaulių', 'Panevėžio', 'Alytaus'
  ];
  return districts[Math.floor(Math.random() * districts.length)];
}

async function seedData() {
  console.log('Starting data seeding...');

  try {
    // Clear existing data
    console.log('Clearing existing data...');
    await db.delete(votes);
    await db.delete(quizAnswers);
    await db.delete(quizQuestions);
    await db.delete(mpStats);
    await db.delete(bills);
    await db.delete(mps);

    // Generate 50 MPs
    console.log('Generating MPs...');
    const mpData = [];
    for (let i = 1; i <= 50; i++) {
      const party = parties[Math.floor(Math.random() * parties.length)];
      mpData.push({
        seimasId: `MP-${i.toString().padStart(4, '0')}`,
        name: generateMpName(),
        party,
        faction: party,
        district: generateDistrict(),
        districtNumber: i,
        email: `mp${i}@lrs.lt`,
        phone: `+370 5 239 ${String(6000 + i).padStart(4, '0')}`,
        photoUrl: `https://api.dicebear.com/7.x/avataaars/svg?seed=mp${i}`,
        biography: `Seimo narys nuo 2024 m. Atstovauja ${generateDistrict()} apygardą. Aktyviai dalyvauja įstatymų leidybos procese.`,
        isActive: true,
      });
    }

    await db.insert(mps).values(mpData);
    console.log(`✓ Inserted ${mpData.length} MPs`);

    // Get inserted MPs to use their IDs
    const insertedMps = await db.select().from(mps);

    // Generate MP statistics
    console.log('Generating MP statistics...');
    const statsData = insertedMps.map(mp => ({
      mpId: mp.id,
      votingAttendance: (85 + Math.random() * 15).toFixed(2),
      partyLoyalty: (75 + Math.random() * 20).toFixed(2),
      billsProposed: Math.floor(Math.random() * 20),
      billsPassed: Math.floor(Math.random() * 10),
      accountabilityScore: (70 + Math.random() * 25).toFixed(2),
    }));

    await db.insert(mpStats).values(statsData);
    console.log(`✓ Inserted ${statsData.length} MP statistics`);

    // Generate bills
    console.log('Generating bills...');
    const billCategories = ['Švietimas', 'Sveikata', 'Ekonomika', 'Aplinka', 'Socialinė apsauga', 'Teisingumo'];
    const billStatuses = ['proposed', 'voted', 'passed', 'rejected'];
    
    const billData = [];
    for (let i = 1; i <= 100; i++) {
      const category = billCategories[Math.floor(Math.random() * billCategories.length)];
      const status = billStatuses[Math.floor(Math.random() * billStatuses.length)];
      
      billData.push({
        seimasId: `BILL-${i.toString().padStart(5, '0')}`,
        title: `${category} įstatymo projektas Nr. ${i}`,
        description: `Įstatymo projektas, skirtas ${category.toLowerCase()} srities klausimams spręsti.`,
        explanatoryNotes: `Detalus paaiškinimas apie ${category.toLowerCase()} įstatymo projekto tikslus ir numatomas priemones.`,
        status,
        category,
        submittedAt: new Date(2024, Math.floor(Math.random() * 12), Math.floor(Math.random() * 28) + 1),
        votedAt: status !== 'proposed' ? new Date(2024, Math.floor(Math.random() * 12), Math.floor(Math.random() * 28) + 1) : null,
      });
    }

    await db.insert(bills).values(billData);
    console.log(`✓ Inserted ${billData.length} bills`);

    // Get inserted bills
    const insertedBills = await db.select().from(bills);

    // Generate votes (each MP votes on 30 random bills)
    console.log('Generating votes...');
    const voteValues = ['for', 'against', 'abstain', 'absent'];
    const voteData = [];

    for (const mp of insertedMps) {
      // Select 30 random bills
      const billsToVote = insertedBills
        .sort(() => Math.random() - 0.5)
        .slice(0, 30);

      for (const bill of billsToVote) {
        const voteValue = voteValues[Math.floor(Math.random() * voteValues.length)];
        voteData.push({
          billId: bill.id,
          mpId: mp.id,
          voteValue,
          votedAt: bill.votedAt || new Date(),
        });
      }
    }

    await db.insert(votes).values(voteData);
    console.log(`✓ Inserted ${voteData.length} votes`);

    // Generate quiz questions
    console.log('Generating quiz questions...');
    const quizData = [
      { questionText: 'Ar palaikote mokesčių didinimą didžiausiems uždirbantiems?', category: 'Ekonomika' },
      { questionText: 'Ar turėtų būti įvestas nemokamas aukštasis išsilavinimas visiems?', category: 'Švietimas' },
      { questionText: 'Ar palaikote griežtesnius aplinkosaugos reikalavimus verslui?', category: 'Aplinka' },
      { questionText: 'Ar reikėtų didinti socialines išmokas šeimoms su vaikais?', category: 'Socialinė apsauga' },
      { questionText: 'Ar palaikote visuotinį sveikatos draudimą?', category: 'Sveikata' },
      { questionText: 'Ar turėtų būti sugriežtintos bausmės už korupciją?', category: 'Teisingumo' },
      { questionText: 'Ar palaikote atsinaujinančių energijos šaltinių plėtrą?', category: 'Aplinka' },
      { questionText: 'Ar reikėtų mažinti biurokratiją smulkiam verslui?', category: 'Ekonomika' },
    ];

    await db.insert(quizQuestions).values(quizData);
    console.log(`✓ Inserted ${quizData.length} quiz questions`);

    // Get inserted questions
    const insertedQuestions = await db.select().from(quizQuestions);

    // Generate quiz answers (each MP answers all questions)
    console.log('Generating quiz answers...');
    const answerValues = ['agree', 'disagree', 'neutral'];
    const answerData = [];

    for (const mp of insertedMps) {
      for (const question of insertedQuestions) {
        const answer = answerValues[Math.floor(Math.random() * answerValues.length)];
        answerData.push({
          questionId: question.id,
          mpId: mp.id,
          answer,
        });
      }
    }

    await db.insert(quizAnswers).values(answerData);
    console.log(`✓ Inserted ${answerData.length} quiz answers`);

    console.log('\n✅ Data seeding completed successfully!');
    console.log(`\nSummary:`);
    console.log(`- ${mpData.length} MPs`);
    console.log(`- ${billData.length} Bills`);
    console.log(`- ${voteData.length} Votes`);
    console.log(`- ${quizData.length} Quiz Questions`);
    console.log(`- ${answerData.length} Quiz Answers`);

  } catch (error) {
    console.error('Error seeding data:', error);
    throw error;
  }

  process.exit(0);
}

seedData();
