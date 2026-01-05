              return (
                <Link key={mp.id} href={`/mp/${mp.id}`}>
                  <Card className="h-full hover:shadow-lg transition-all duration-200 hover:-translate-y-1 cursor-pointer group">
                    <CardHeader>
                      <div className={`flex ${viewMode === "grid" ? "flex-col items-center text-center" : "flex-row items-start"} gap-4`}>
                        <Avatar className={viewMode === "grid" ? "w-20 h-20" : "w-16 h-16"}>
                          <AvatarImage src={mp.photoUrl ?? undefined} />
                          <AvatarFallback className="text-lg">
                            {mp.name.split(' ').map(n => n[0]).join('')}
                          </AvatarFallback>
                        </Avatar>
                        <div className="flex-1 min-w-0">
                          <CardTitle className="text-lg group-hover:text-primary transition-colors mb-2">
                            {mp.name}
                          </CardTitle>
                          <Badge variant="outline" className="mb-2 text-xs">
                            {mp.party}
                          </Badge>
                          {mp.district && (
                            <div className="flex items-center gap-1 text-xs text-muted-foreground">
                              <MapPin className="h-3 w-3" />
                              {mp.district}
                            </div>
                          )}
                        </div>
                      </div>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        {/* Accountability Score */}
                        <div>
                          <div className="flex items-center justify-between mb-2">
                            <span className="text-sm text-muted-foreground">Atskaitomybė</span>
                            <span className={`text-sm font-bold ${scoreColor}`}>
                              {score ? `${parseFloat(score).toFixed(0)}%` : "N/A"}
                            </span>
                          </div>
                          <Progress 
                            value={score ? parseFloat(score) : 0} 
                            className="h-2"
                            indicatorClassName={
                              score && parseFloat(score) >= 85 ? "bg-green-600" :
                              score && parseFloat(score) >= 70 ? "bg-yellow-600" :
                              "bg-red-600"
                            }
                          />
                          <p className="text-xs text-muted-foreground mt-1">{scoreLabel}</p>
                        </div>

                        {/* Quick Stats */}
                        <div className="grid grid-cols-2 gap-2 text-xs">
                          <div className="bg-muted/50 rounded p-2">
                            <p className="text-muted-foreground">Dalyvavimas</p>
                            <p className="font-semibold">
                              {mp.stats?.votingAttendance ? `${parseFloat(mp.stats.votingAttendance).toFixed(0)}%` : "—"}
                            </p>
                          </div>
                          <div className="bg-muted/50 rounded p-2">
                            <p className="text-muted-foreground">Projektai</p>
                            <p className="font-semibold">
                              {mp.stats?.billsProposed || 0}
                            </p>
                          </div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
