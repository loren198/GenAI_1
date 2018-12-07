/*********************************************
 * OPL 12.7.0.0 Model
 * Author: l.sanmartin
 * Creation Date: Dec 3, 2018 at 9:36:37 AM
 *********************************************/

 using CP;
 
 int NbTask=...;             /*Number of tasks to be scheduled*/
 int NbRscrs=...;            /*Number of different resources*/
 int NbSkills=...;           /*Number of different skills*/
 int NbWorkers=...;          /*Number of workers*/
 
 range RscrsId=0..NbRscrs-1;   /*range used for indices related to number of resources*/
 range SkillsId=0..NbSkills-1; /*range used for indices related to number of skills*/
 
 int Capacity[r in RscrsId] = ... ;
 
 /*Definition of tuple Task:contains the identifier id, the duration pt, 
 the resources required dmds, skills required skilldmds and the succesors succs*/
 tuple Task {
 key int id;
 int pt;
 int dmds [RscrsId];
 int skilldmds[SkillsId];
 {int} succs;
}

{Task} Tasks=...;

/* Definition of Skill: name of worker, can they perform skill?*/
tuple Skill {
string worker;
int level;
}

{Skill} Skills=...;


dvar interval itvs [t in Tasks] size t.pt; /*Decision variable interval*/
dvar boolean  as_worker[w in 0..NbWorkers,t in Tasks]; /*Decision variable assigned worker to each task*/

/*Cumulative function for resource capacity : pulse (interval, demand)*/
cumulFunction rscrsUsage[r in RscrsId]=
sum (t in Tasks: t.dmds[r]>0) pulse(itvs[t],t.dmds[r]);

/*Objective: minimize finishing time. Later on this should be changed to the right expression*/
minimize max(t in Tasks) endOf (itvs[t]);



/* constraints*/
subject to {

/*maximum capacity constraint*/
forall (r in RscrsId)
  rscrsUsage[r]<=Capacity[r];
 
 /* precedence constraint*/ 
forall (t1 in Tasks, t2id in t1.succs)
  endBeforeStart(itvs[t1], itvs[<t2id>]);
  
  

/* One worker can only perform one task at a time
what I tried to do: for all tasks in Tasks that are performed by the same worker (have same w in assigned worker ),
there cannot be a superposition of tasks*/
forall(w in as_worker)
  noOverlap(all(t in Tasks: as_worker[w]==1)Tasks[t]);
  
  /*compare assigned worker skills to the required skills. How?*/
  }  
  
  
  
  
  /*Currently missing  ??two?? constraints: do not exceed maximum worker capacity (might already be given by noOverlap) and assign worker
  to each task based on their skills*/