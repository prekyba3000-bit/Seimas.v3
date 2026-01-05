import { useState, useEffect } from "react";
import { useLocation } from "wouter";
import { 
  Users,
  FileText,
  TrendingUp,
  Award,
  ArrowRight,
  Zap
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { trpc } from "@/lib/trpc";

export default function Home() {
  const [, navigate] = useLocation();

  // Fetch all MPs
  const { data: mps, isLoading: mpsLoading } = trpc.mps.list.useQuery({
    isActive: true,
  });

  // Fetch all bills
  const { data: bills, isLoading: billsLoading } = trpc.bills.list.useQuery({});

  // Fetch stats for top MPs
  const topMpsIds = (mps || []).slice(0, 5).map(mp => mp.id);
  const topMpsStatsQueries = trpc.useQueries((t) =>
    topMpsIds.map((mpId) => t.mps.stats({ mpId }))
  );

  // Calculate overall statistics
  const totalMps = mps?.length || 0;
  const totalBills = bills?.length || 0;
  const avgScore = (mps || []).reduce((sum, mp, index) => {
    const stats = topMpsStatsQueries[index]?.data;
    return sum + (stats ? parseFloat(stats.accountabilityScore) : 0);
  }, 0) / Math.max(topMpsIds.length, 1);

  return (
    <div className="min-h-screen bg-background">
      {/* Hero Section */}
      <section className="border-b bg-gradient-to-br from-primary/10 via-background to-accent/5 py-20">
        <div className="container">
          <div className="max-w-3xl mx-auto text-center space-y-6">
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-primary/10 border border-primary/20">
              <Zap className="h-4 w-4 text-primary" />
              <span className="text-sm font-medium text-primary">Skaidrus Seimas</span>
            </div>
            
            <h1 className="text-5xl md:text-6xl font-bold tracking-tight">
              Skaidri Lietuvos <span className="text-primary">Parlamentinė Demokratija</span>
            </h1>
            
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              Susipažinkite su Lietuvos Respublikos Seimo nariais, jų veiklos statistika ir balsavimų istorija. Saugokite savo demokratiją per informaciją.
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center pt-4">
              <Button size="lg" onClick={() => navigate("/mps")}>
                Peržiūrėti Seimo Narius
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
              <Button size="lg" variant="outline" onClick={() => navigate("/bills")}>
                Naujausios Sąmatos
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Statistics Overview */}
      <section className="py-16 border-b">
        <div className="container">
          <h2 className="text-3xl font-bold tracking-tight mb-12">Pagrindiniai Rodikliai</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground mb-1">Seimo Nariai</p>
                    <p className="text-3xl font-bold">{totalMps}</p>
                    <p className="text-xs text-muted-foreground mt-2">Aktyvūs nariai</p>
                  </div>
                  <Users className="h-12 w-12 text-primary opacity-20" />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground mb-1">Sąmatos</p>
                    <p className="text-3xl font-bold">{totalBills}</p>
                    <p className="text-xs text-muted-foreground mt-2">Iš viso sąmatų</p>
                  </div>
                  <FileText className="h-12 w-12 text-primary opacity-20" />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground mb-1">Vidutinis Įvertinimas</p>
                    <p className="text-3xl font-bold">{avgScore.toFixed(1)}</p>
                    <p className="text-xs text-muted-foreground mt-2">Atskaitomybės balas</p>
                  </div>
                  <Award className="h-12 w-12 text-primary opacity-20" />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground mb-1">Skaidrumas</p>
                    <p className="text-3xl font-bold">100%</p>
                    <p className="text-xs text-muted-foreground mt-2">Atvirų duomenų</p>
                  </div>
                  <TrendingUp className="h-12 w-12 text-primary opacity-20" />
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Featured MPs */}
      <section className="py-16 border-b">
        <div className="container">
          <div className="flex items-center justify-between mb-12">
            <h2 className="text-3xl font-bold tracking-tight">Aukščiausiai Vertinami Seimo Nariai</h2>
            <Button variant="outline" onClick={() => navigate("/mps")}>
              Peržiūrėti Visus
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
            {mpsLoading ? (
              [...Array(5)].map((_, i) => (
                <Card key={i} className="animate-pulse">
                  <CardContent className="pt-6">
                    <div className="flex flex-col items-center text-center space-y-4">
                      <div className="w-16 h-16 rounded-full bg-muted" />
                      <div className="w-full space-y-2">
                        <div className="h-4 bg-muted rounded w-3/4 mx-auto" />
                        <div className="h-3 bg-muted rounded w-1/2 mx-auto" />
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))
            ) : (
              (mps || []).slice(0, 5).map((mp, index) => {
                const stats = topMpsStatsQueries[index]?.data;
                const score = stats ? parseFloat(stats.accountabilityScore) : 0;
                
                return (
                  <Card 
                    key={mp.id}
                    className="hover:shadow-lg transition-all duration-200 hover:-translate-y-1 cursor-pointer group"
                    onClick={() => navigate(`/mp/${mp.id}`)}
                  >
                    <CardContent className="pt-6">
                      <div className="flex flex-col items-center text-center space-y-4">
                        <Avatar className="w-16 h-16">
                          <AvatarImage src={mp.photoUrl || undefined} />
                          <AvatarFallback className="text-lg">
                            {mp.name.split(' ').map(n => n[0]).join('')}
                          </AvatarFallback>
                        </Avatar>
                        
                        <div className="min-w-0">
                          <h3 className="font-semibold text-sm group-hover:text-primary transition-colors line-clamp-2">
                            {mp.name}
                          </h3>
                          <p className="text-xs text-muted-foreground">{mp.party}</p>
                        </div>

                        <div className="w-full">
                          <div className="flex items-center justify-between mb-2">
                            <span className="text-xs text-muted-foreground">Atskaitomybė</span>
                            <span className={`text-xs font-bold ${
                              score >= 85 ? 'text-green-600' :
                              score >= 70 ? 'text-yellow-600' :
                              'text-red-600'
                            }`}>
                              {score.toFixed(0)}%
                            </span>
                          </div>
                          <div className="w-full bg-muted rounded-full h-2 overflow-hidden">
                            <div 
                              className={`h-full transition-all ${
                                score >= 85 ? 'bg-green-600' :
                                score >= 70 ? 'bg-yellow-600' :
                                'bg-red-600'
                              }`}
                              style={{ width: `${Math.min(score, 100)}%` }}
                            />
                          </div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                );
              })
            )}
          </div>
        </div>
      </section>

      {/* Recent Bills */}
      <section className="py-16 border-b">
        <div className="container">
          <div className="flex items-center justify-between mb-12">
            <h2 className="text-3xl font-bold tracking-tight">Naujausios Sąmatos</h2>
            <Button variant="outline" onClick={() => navigate("/bills")}>
              Peržiūrėti Visas
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </div>

          <div className="space-y-4">
            {billsLoading ? (
              [...Array(3)].map((_, i) => (
                <Card key={i} className="animate-pulse">
                  <CardContent className="pt-6">
                    <div className="space-y-3">
                      <div className="h-4 bg-muted rounded w-3/4" />
                      <div className="h-3 bg-muted rounded w-1/2" />
                    </div>
                  </CardContent>
                </Card>
              ))
            ) : (
              (bills || []).slice(0, 3).map((bill) => (
                <Card 
                  key={bill.id}
                  className="hover:shadow-md transition-all duration-200 cursor-pointer group"
                  onClick={() => navigate(`/bills/${bill.id}`)}
                >
                  <CardContent className="pt-6">
                    <div className="flex items-start justify-between gap-4">
                      <div className="flex-1 min-w-0">
                        <h3 className="font-semibold group-hover:text-primary transition-colors mb-2">
                          {bill.title}
                        </h3>
                        <p className="text-sm text-muted-foreground line-clamp-2">
                          {bill.description || "Aprašymas nėra prieinas"}
                        </p>
                        <div className="flex items-center gap-2 mt-3 flex-wrap">
                          <Badge variant="outline" className="text-xs">
                            {bill.category || "Neklasifikuota"}
                          </Badge>
                          <Badge 
                            className={`text-xs ${
                              bill.status === 'passed' ? 'bg-green-100 text-green-800' :
                              bill.status === 'rejected' ? 'bg-red-100 text-red-800' :
                              'bg-blue-100 text-blue-800'
                            }`}
                          >
                            {bill.status === 'passed' ? 'Priimta' :
                             bill.status === 'rejected' ? 'Atmesta' :
                             'Svarsoma'}
                          </Badge>
                        </div>
                      </div>
                      <div className="text-right text-sm text-muted-foreground">
                        {bill.createdAt ? new Date(bill.createdAt).toLocaleDateString('lt-LT') : '—'}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))
            )}
          </div>
        </div>
      </section>

      {/* Call to Action */}
      <section className="py-16 bg-gradient-to-br from-primary/10 to-accent/5">
        <div className="container">
          <div className="max-w-2xl mx-auto text-center space-y-6">
            <h2 className="text-3xl font-bold tracking-tight">
              Pradėkite Skaitytis Parlamentą
            </h2>
            <p className="text-lg text-muted-foreground">
              Peržiūrėkite Seimo narių veiklą, balsavimų istoriją ir legislacinę veiklą. Skaidri demokratija prasideda nuo informuoto piliečio.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center pt-4">
              <Button size="lg" onClick={() => navigate("/mps")}>
                Peržiūrėti Seimo Narius
              </Button>
              <Button size="lg" variant="outline" onClick={() => navigate("/bills")}>
                Peržiūrėti Sąmatas
              </Button>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
