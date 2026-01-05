import { useState, useEffect } from "react";
import { useRoute, useLocation } from "wouter";
import { 
  ArrowLeft, 
  Mail, 
  Phone, 
  MapPin, 
  Share2, 
  Heart, 
  Download,
  Calendar,
  ExternalLink,
  Info
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Separator } from "@/components/ui/separator";
import { 
  StatisticsCard, 
  AccountabilityScore, 
  VotingBreakdownChart, 
  LegislativeActivity 
} from "@/components/DemoComponents";
import { DistrictMap } from "@/components/DistrictMap";
import { trpc } from "@/lib/trpc";

export default function MPProfile() {
  const [, params] = useRoute("/mp/:id");
  const [, navigate] = useLocation();
  const mpId = params?.id ? parseInt(params.id, 10) : null;

  const [isFollowing, setIsFollowing] = useState(false);
  const [activeTab, setActiveTab] = useState("overview");

  // Fetch MP data
  const { data: mp, isLoading: mpLoading, error: mpError } = trpc.mps.byId.useQuery(
    { id: mpId! },
    { enabled: !!mpId }
  );

  // Fetch MP stats
  const { data: stats, isLoading: statsLoading } = trpc.mps.stats.useQuery(
    { mpId: mpId! },
    { enabled: !!mpId }
  );

  // Fetch MP votes
  const { data: votesData, isLoading: votesLoading } = trpc.votes.byMp.useQuery(
    { mpId: mpId!, limit: 50 },
    { enabled: !!mpId }
  );

  // Calculate voting breakdown
  const votingBreakdown = (votesData || []).reduce(
    (acc, item) => {
      const vote = item.vote;
      if (vote.voteValue === 'for') acc.votesFor++;
      else if (vote.voteValue === 'against') acc.votesAgainst++;
      else if (vote.voteValue === 'abstain') acc.abstentions++;
      else if (vote.voteValue === 'absent') acc.absences++;
      return acc;
    },
    { votesFor: 0, votesAgainst: 0, abstentions: 0, absences: 0 }
  );

  const isLoading = mpLoading || statsLoading || votesLoading;

  if (!mpId) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <p className="text-muted-foreground">Seimo nario ID nėra nurodytas</p>
          <Button className="mt-4" onClick={() => navigate("/mps")}>
            Grįžti į Seimo narius
          </Button>
        </div>
      </div>
    );
  }

  if (mpError) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <p className="text-red-600 font-medium mb-2">Klaida: Seimo nario nepavyko įkelti</p>
          <p className="text-muted-foreground mb-4">{mpError.message}</p>
          <Button onClick={() => navigate("/mps")}>
            Grįžti į Seimo narius
          </Button>
        </div>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground animate-pulse">Įkeliama Seimo nario informacija...</p>
        </div>
      </div>
    );
  }

  if (!mp) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <p className="text-muted-foreground">Seimo naris nerastas</p>
          <Button className="mt-4" onClick={() => navigate("/mps")}>
            Grįžti į Seimo narius
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background pb-12">
      {/* Profile Header Section */}
      <section className="border-b bg-gradient-to-br from-primary/5 to-accent/10 pt-8 pb-12">
        <div className="container">
          <Button 
            variant="ghost" 
            className="mb-6 pl-0 hover:bg-transparent hover:text-primary"
            onClick={() => navigate("/mps")}
          >
            <ArrowLeft className="mr-2 h-4 w-4" />
            Grįžti į Sąrašą
          </Button>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Profile Info */}
            <div className="lg:col-span-2">
              <div className="flex flex-col md:flex-row gap-8 items-start">
                <div className="relative group">
                  <div className="absolute -inset-0.5 bg-gradient-to-r from-primary to-accent rounded-full opacity-75 blur group-hover:opacity-100 transition duration-1000 group-hover:duration-200"></div>
                  <img
                    src={mp.photoUrl || "https://via.placeholder.com/160"}
                    alt={mp.name}
                    className="relative w-40 h-40 rounded-full object-cover border-4 border-background shadow-xl"
                  />
                  <Badge className="absolute bottom-2 right-2 bg-green-600 hover:bg-green-700 border-2 border-white">
                    {mp.isActive ? "Aktyvus" : "Neaktyvus"}
                  </Badge>
                </div>

                <div className="flex-1 space-y-4">
                  <div>
                    <h1 className="text-4xl font-bold tracking-tight text-foreground mb-2">{mp.name}</h1>
                    <div className="flex flex-wrap gap-2">
                      <Badge variant="secondary" className="text-sm px-3 py-1 font-medium">
                        {mp.party}
                      </Badge>
                      {mp.faction && (
                        <Badge variant="outline" className="text-sm px-3 py-1">
                          {mp.faction}
                        </Badge>
                      )}
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-sm text-muted-foreground">
                    {mp.district && (
                      <div className="flex items-center gap-2 p-2 rounded-md hover:bg-background/50 transition-colors">
                        <MapPin className="h-4 w-4 text-primary" />
                        <span>{mp.district} apygarda ({mp.districtNumber})</span>
                      </div>
                    )}
                    {mp.email && (
                      <div className="flex items-center gap-2 p-2 rounded-md hover:bg-background/50 transition-colors">
                        <Mail className="h-4 w-4 text-primary" />
                        <a href={`mailto:${mp.email}`} className="hover:text-primary hover:underline">
                          {mp.email}
                        </a>
                      </div>
                    )}
                    {mp.phone && (
                      <div className="flex items-center gap-2 p-2 rounded-md hover:bg-background/50 transition-colors">
                        <Phone className="h-4 w-4 text-primary" />
                        <a href={`tel:${mp.phone}`} className="hover:text-primary hover:underline">
                          {mp.phone}
                        </a>
                      </div>
                    )}
                    <div className="flex items-center gap-2 p-2 rounded-md hover:bg-background/50 transition-colors">
                      <Calendar className="h-4 w-4 text-primary" />
                      <span>Kadencija: 2024-2028</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Quick Actions Card */}
            <div className="lg:col-span-1">
              <Card className="shadow-lg border-primary/10 bg-card/80 backdrop-blur-sm">
                <CardHeader className="pb-3">
                  <CardTitle className="text-lg">Veiksmai</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  <Button 
                    className="w-full justify-start text-base" 
                    variant={isFollowing ? "secondary" : "default"}
                    onClick={() => setIsFollowing(!isFollowing)}
                  >
                    <Heart className={`mr-2 h-5 w-5 ${isFollowing ? 'fill-red-500 text-red-500' : ''}`} />
                    {isFollowing ? 'Jūs sekate šį narį' : 'Sekti veiklos ataskaitas'}
                  </Button>
                  <div className="grid grid-cols-2 gap-3">
                    <Button variant="outline" className="w-full justify-start">
                      <Share2 className="mr-2 h-4 w-4" />
                      Dalintis
                    </Button>
                    <Button variant="outline" className="w-full justify-start">
                      <Download className="mr-2 h-4 w-4" />
                      Ataskaita
                    </Button>
                  </div>
                  <Button variant="ghost" className="w-full justify-start text-muted-foreground hover:text-primary">
                    <ExternalLink className="mr-2 h-4 w-4" />
                    Oficialus puslapis
                  </Button>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </section>

      {/* Main Content */}
      <main className="container py-10">
        <Tabs defaultValue="overview" className="space-y-8" onValueChange={setActiveTab}>
          <TabsList className="grid w-full max-w-xl grid-cols-4 bg-muted/50 p-1">
            <TabsTrigger value="overview">Apžvalga</TabsTrigger>
            <TabsTrigger value="votes">Balsavimai</TabsTrigger>
            <TabsTrigger value="map">Apygarda</TabsTrigger>
            <TabsTrigger value="biography">Biografija</TabsTrigger>
          </TabsList>

          <TabsContent value="overview" className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-3xl font-bold tracking-tight">Veiklos Statistika</h2>
                <p className="text-muted-foreground mt-1">
                  Duomenys atnaujinti: {stats?.lastCalculated ? new Date(stats.lastCalculated).toLocaleDateString('lt-LT') : 'Nežinoma'}
                </p>
              </div>
              <Badge variant="outline" className="hidden sm:flex gap-1 px-3 py-1">
                <Info className="h-3 w-3" />
                Metodologija
              </Badge>
            </div>

            {/* Statistics Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Accountability Score - Featured */}
              <div className="lg:col-span-1 h-full">
                <AccountabilityScore
                  score={stats ? parseFloat(stats.accountabilityScore) : 0}
                  votingAttendance={stats ? parseFloat(stats.votingAttendance) : 0}
                  partyLoyalty={stats ? parseFloat(stats.partyLoyalty) : 0}
                  accountabilityFlags={0}
                />
              </div>

              {/* Key Metrics */}
              <div className="lg:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-6">
                <StatisticsCard
                  title="Balsavimo Dalyvavimas"
                  value={stats ? parseFloat(stats.votingAttendance) : 0}
                  unit="%"
                  description={stats && parseFloat(stats.votingAttendance) >= 80 ? "Aukštas dalyvavimo rodiklis" : "Vidutinis dalyvavimas"}
                  tooltip="Procentas balsavimų, kuriuose narys dalyvavo (nebuvo pažymėtas kaip nedalyvavęs)"
                  showProgress={true}
                  trend={stats && parseFloat(stats.votingAttendance) >= 80 ? "up" : "neutral"}
                />
                <StatisticsCard
                  title="Partijos Lojalumas"
                  value={stats ? parseFloat(stats.partyLoyalty) : 0}
                  unit="%"
                  description={stats && parseFloat(stats.partyLoyalty) >= 80 ? "Griežtai laikosi partijos linijos" : "Kartais balsavimas skirtingai"}
                  tooltip="Procentas balsavimų, kai narys balsavo taip pat kaip jo partija"
                  showProgress={true}
                  trend={stats && parseFloat(stats.partyLoyalty) >= 80 ? "up" : "neutral"}
                />
              </div>
            </div>

            {/* Detailed Charts */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <VotingBreakdownChart
                votesFor={votingBreakdown.votesFor}
                votesAgainst={votingBreakdown.votesAgainst}
                abstentions={votingBreakdown.abstentions}
                absences={votingBreakdown.absences}
                totalVotes={votesData?.length || 0}
              />
              <LegislativeActivity
                billsProposed={stats?.billsProposed || 0}
                billsPassed={stats?.billsPassed || 0}
              />
            </div>
          </TabsContent>

          <TabsContent value="map" className="animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <div className="lg:col-span-2">
                <DistrictMap 
                  districtName={mp.district || "Nežinoma"} 
                  districtNumber={mp.districtNumber || 0} 
                />
              </div>
              <div className="lg:col-span-1 space-y-6">
                <Card>
                  <CardHeader>
                    <CardTitle>Apygardos Informacija</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex justify-between py-2 border-b">
                      <span className="text-muted-foreground">Apygarda</span>
                      <span className="font-medium">{mp.district || "—"}</span>
                    </div>
                    <div className="flex justify-between py-2 border-b">
                      <span className="text-muted-foreground">Apygardos Nr.</span>
                      <span className="font-medium">{mp.districtNumber || "—"}</span>
                    </div>
                    <div className="flex justify-between py-2">
                      <span className="text-muted-foreground">Seimo nario statusas</span>
                      <span className="font-medium">{mp.isActive ? "Aktyvus" : "Neaktyvus"}</span>
                    </div>
                  </CardContent>
                </Card>
                
                <Card>
                  <CardHeader>
                    <CardTitle>Kontaktinė Informacija</CardTitle>
                    <CardDescription>Seimo nario kontaktai</CardDescription>
                  </CardHeader>
                  <CardContent className="space-y-3 text-sm">
                    {mp.email && (
                      <div className="flex items-start gap-3">
                        <Mail className="h-4 w-4 text-primary mt-0.5" />
                        <div>
                          <p className="font-medium">El. paštas</p>
                          <p className="text-muted-foreground">{mp.email}</p>
                        </div>
                      </div>
                    )}
                    {mp.phone && (
                      <div className="flex items-center gap-3">
                        <Phone className="h-4 w-4 text-primary" />
                        <p>{mp.phone}</p>
                      </div>
                    )}
                  </CardContent>
                </Card>
              </div>
            </div>
          </TabsContent>

          <TabsContent value="votes" className="animate-in fade-in slide-in-from-bottom-4 duration-500">
            <Card>
              <CardHeader>
                <CardTitle>Paskutiniai Balsavimai</CardTitle>
                <CardDescription>
                  {votesData?.length || 0} naujausių balsavimų išklotinė
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {votesData && votesData.length > 0 ? (
                    votesData.slice(0, 10).map((item, index) => {
                      const vote = item.vote;
                      const bill = item.bill;
                      return (
                        <div
                          key={index}
                          className="flex items-center justify-between p-4 border rounded-lg hover:bg-muted/30 transition-colors group"
                        >
                          <div className="flex-1 pr-4">
                            <div className="flex items-center gap-2 mb-1">
                              <Badge variant="outline" className="text-xs font-normal text-muted-foreground">
                                #{vote.billId}
                              </Badge>
                            <span className="text-xs text-muted-foreground">
                              {vote.votedAt ? new Date(vote.votedAt).toLocaleDateString('lt-LT') : '—'}
                            </span>
                            </div>
                            <p className="font-medium group-hover:text-primary transition-colors line-clamp-1">
                              {bill?.title || "Nežinomas balsavimas"}
                            </p>
                          </div>
                          <Badge
                            className={
                              vote.voteValue === 'for'
                                ? 'bg-green-100 text-green-800 hover:bg-green-200 border-green-200'
                                : vote.voteValue === 'against'
                                ? 'bg-red-100 text-red-800 hover:bg-red-200 border-red-200'
                                : vote.voteValue === 'abstain'
                                ? 'bg-yellow-100 text-yellow-800 hover:bg-yellow-200 border-yellow-200'
                                : 'bg-slate-100 text-slate-800 hover:bg-slate-200 border-slate-200'
                            }
                          >
                            {vote.voteValue === 'for'
                              ? 'Už'
                              : vote.voteValue === 'against'
                              ? 'Prieš'
                              : vote.voteValue === 'abstain'
                              ? 'Susilaikė'
                              : 'Nedalyvavo'}
                          </Badge>
                        </div>
                      );
                    })
                  ) : (
                    <p className="text-center text-muted-foreground py-8">Nėra balsavimo duomenų</p>
                  )}
                  {votesData && votesData.length > 10 && (
                    <Button variant="outline" className="w-full mt-4">
                      Rodyti daugiau balsavimų
                    </Button>
                  )}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="biography" className="animate-in fade-in slide-in-from-bottom-4 duration-500">
            <Card>
              <CardHeader>
                <CardTitle>Biografija</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="prose prose-slate max-w-none">
                  <p className="leading-relaxed text-lg text-muted-foreground">
                    {mp.biography || "Biografija nėra prieinama"}
                  </p>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </main>
    </div>
  );
}
