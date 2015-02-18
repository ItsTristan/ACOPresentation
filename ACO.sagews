︠fcbfc66d-4dd9-4583-8fe0-3173fdf890f4s︠
G_SIZE = 20
W_LO_BOUND = 1
W_HI_BOUND = 10
P_CONNECTED = 0.8

G = DiGraph()
G.weighted(True)
G.allow_multiple_edges(True)

# Generate K_n
for u in range(G_SIZE):
    for v in range(u, G_SIZE):
        if P_CONNECTED < random(): continue
        G.add_edge((u, v, randint(W_LO_BOUND, W_HI_BOUND)))
        G.add_edge((v, u, randint(W_LO_BOUND, W_HI_BOUND)))
# Display
# G.show(edge_labels=True)
print "Done"
︡505d3f2c-a323-4369-9b91-10d19fba650d︡{"stdout":"Done\n"}︡
︠f50ba3fb-599a-4020-ad6c-b248324efbc5s︠
from random import choice, shuffle

print "Starting..."

def weighted_choice(choices, weights):
    s = sum(weights)
    r = random() * s
    x = 0
    for i in range(len(weights)):
        x += weights[i]
        if r < x:
            return choices[i]
        r -= weights[i]
    # Nothing selected? Weights might be 0
    return choice(choices)

_best_so_far = float('inf')
_best_solution = None

lg_points = {}
lg_means = {}

def ACO_TSP(G, N=5000, A=15, Q=2, rho=0.1):
    global _best_so_far, _best_solution
    pheromones = {}
    for u,v,w in G.edges():
        pheromones[u,v] = pheromones[v,u] = 0

    # ant starts at vertex 0
    ants = [0 for a in range(A)]
    paths = [[a] for a in ants]
    eps = [random()*0. for a in ants]
    _best_so_far = float('inf')
    _best_solution = None

    def updatePheromones(cycle, iterations):
        global _best_so_far, _best_solution
        quantity = Q / len(cycle)

        visited = set()
        solution = []
        solution_sum = 0
        u, v = None, cycle.pop(0)
        while cycle:
            u,v = v, cycle.pop(0)
            edge = [(a,b,w) for (a,b,w) in G.edges() if a==u and b==v][0]
            solution.append(edge)
            solution_sum += edge[2]
            # Apply update rule
            pheromones[u,v] = pheromones[u,v] + quantity

        it = (iterations // 100) * 100
        # Update means plot
        n, value = lg_means.get(it, (0,0))
        lg_means[it] = n+1, value + (solution_sum - value) / (n+1)
        # Update min plot
        n, value = lg_points.get(it, (0,Infinity))
        lg_points[it] = n+1, min(value, solution_sum)

        if solution_sum < _best_so_far:
            _best_so_far = solution_sum
            _best_solution = solution
            return True
        return False

    for i in range(N):
        for a,ant in enumerate(ants):
            # Vertices seen before
            seen = paths[a][1-G.num_verts():]
            # Potential neighbours
            N = G.edges_incident([ant])
            # Candidate weights
            C = [pheromones[edge[:2]]+Q*int(edge[1] not in seen) for edge in N]

            e = choice(N) if random() < eps[a] else weighted_choice(N, C)

            # If we get an earlier cycle, discard part of the result
            if e[1] in seen:
                p = paths[a]
                paths[a] = p[p.index(e[1])+1:]
            paths[a] = paths[a][:G.num_verts()]

            # Append to path
            paths[a].append(e[1])
            ants[a] = e[1]

        for a,ant in enumerate(ants):
            if len(paths[a]) == G.num_verts()+1:
                if paths[a][0] == paths[a][-1]:
                    cycle = paths[a]
                    if updatePheromones(cycle, i):
                        Graph(_best_solution).show(edge_labels=True)
                        print "Iteration {}, ant {} improved the solution to {}".format(i, a, _best_so_far)
        # Evaporate
        for k in pheromones:
            pheromones[k] *= (1-rho)

    return _best_solution, _best_so_far

C, s = ACO_TSP(G, rho = 1./G.num_verts())
show("Weight: {}".format(s))

# Make a nice line graph
plot(line(sorted([(i, v) for i, (_,v) in lg_points.items()]), color='red', legend_label='min') + line(sorted([(i, v) for i, (_,v) in lg_means.items()]), color='blue', legend_label='mean'))

print "Done"


︡bbf5fb5e-a3ea-47fc-bd6f-4bb08f054b52︡{"stdout":"Starting...\n"}︡{"once":false,"file":{"show":true,"uuid":"89e3da44-d2e8-4a9e-8f84-9d9676ccb2eb","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_0BNQtP.svg"}}︡{"stdout":"Iteration 22, ant 4 improved the solution to 114"}︡{"stdout":"\n"}︡{"once":false,"file":{"show":true,"uuid":"baabcb84-082a-48ec-886c-d9c2c6ba9ae1","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_6sBsOk.svg"}}︡{"stdout":"Iteration 25, ant 2 improved the solution to 92"}︡{"stdout":"\n"}︡{"once":false,"file":{"show":true,"uuid":"612f028e-f57c-4c3c-9bf3-9b5948130d2b","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_R6FpfA.svg"}}︡{"stdout":"Iteration 403, ant 10 improved the solution to 89"}︡{"stdout":"\n"}︡{"once":false,"file":{"show":true,"uuid":"f3c8caff-2d77-4bd4-a2ed-c847fcaed896","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_ZvPS5f.svg"}}︡{"stdout":"Iteration 852, ant 3 improved the solution to 87"}︡{"stdout":"\n"}︡{"once":false,"file":{"show":true,"uuid":"674089b4-ab55-4676-b420-4159c73530b6","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_5sfkNa.svg"}}︡{"stdout":"Iteration 1124, ant 9 improved the solution to 84"}︡{"stdout":"\n"}︡{"once":false,"file":{"show":true,"uuid":"d8a47c03-733d-4694-afe5-f0396d7c6b2c","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_liCVD7.svg"}}︡{"stdout":"Iteration 1195, ant 9 improved the solution to 80"}︡{"stdout":"\n"}︡{"tex":{"tex":"Weight: 80","display":true}}︡{"once":false,"file":{"show":true,"uuid":"46bdcbba-d481-468c-b80d-efa61ac3b39a","filename":"/projects/9468a8a3-4ed4-4cb6-8bc3-0d31f776b0e8/.sage/temp/compute1dc1/3397/tmp_jamPlg.svg"}}︡{"stdout":"Done\n"}︡
︠aa47e452-2671-46d2-a964-ee147b29ef98i︠

G = DiGraph()
for edge in graphs.PetersenGraph().edges():
    u, v, w = edge
    G.add_edge(u,v,1)
    G.add_edge(v,u,1)
show(G)
G.plot(edge_labels=True)

ACO_TSP(G)
print "done"









