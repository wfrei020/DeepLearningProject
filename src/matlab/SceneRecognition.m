% Deep Learning Project
%Author: Walter Freire
%Course: EE8608
%based on the paper Scene Recognition by Manifold regularized deep learning architecture

%lets test sift

function Y=SceneRecognition();
load('15SceneCategoryLarge','dataT','training_label');
data = dataT';
layers = 1;
if(0)
x = 1:size(data,1);
for i=1:size(data,1)
    y(i) = norm(data(i,:),1);
end
figure(1)
scatter(x,y)
end
W = ones(size(data,1));
for L = 1:layers

disp('on a LOOP start')
size(data)



options=make_options;
%options.NN=NN;
options.Kernel='linear';
%options.KernelParam=SIGMA;
%options.gamma_A=gamma_A; 
%options.gamma_I=gamma_I; 
options.GraphWeights='heat';
%options.GraphWeightParam=SIGMA;
%options.LaplacianDegree=DEGREE;
options.PointCloud = data;

M = lle(dataT,5,128);
%already done
%I=eye(size(M')); 
%M = (I-M')*(I-M')';
%what i thought it was
% I=eye(size(M')); 
% M = (I-M')*(I-M')';
options.DeformationMatrix = M;

K=calckernel(options,data);
%I believe up until this part it is correct
%need to loop this eventually properly
disp('size of k');
size(K)
W = (K./(K.*W +0.1.*W+(0.1/4).*(W.^(1/2)))).*W;
disp('size of W');
size(W)
D = eye(size(W)).*((1/2)*(W+W'));
WT = 1/2*(W+W')*(D^(-1));
%WT
%D^(-1)

% WT is nxn
%data is n x d
%D in n x n
% G is n x d
%gmin is d x d
%G = WT;
%WT
%G = D^(1/2)*data;
disp('size of G');

%Gmin = G'*((eye(size(WT,1)) - WT)^2)*G;
%Gmin*Gmin'

disp('size of G min');
%size(Gmin)
%return
Gsym = compute_relation(WT);
disp('size of G sym');
size(Gsym)
%G = compute_relation(dataT);
nbCluster = 128;
[NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(Gsym,nbCluster);
disp('size of  discrete');
size(NcutDiscrete)
disp('size of  vectorr');
size(NcutEigenvectors)
disp('size of  vals');
size(NcutEigenvalues)
disp('size of  D');
size(D)
disp(['The computation took ' num2str(toc) ' seconds']);

 Y = NcutEigenvectors'*inv(D^(1/2));
size(Y)
figure(L+6)
plot(NcutEigenvectors)

YT = Y';
x = 1:size(YT,1);
for i=1:size(YT,1)
    y(i) = norm(YT(i,:),1);
end
figure(L+1)
scatter(x,y)

data = Y';
end
 % figure(1);
%plot(Y);
return
% display clustering result
cluster_color = ['rgbmyc'];
figure(2);clf;
for j=1:nbCluster,
    id = find(NcutDiscrete(:,j));
    plot(data(1,id),data(2,id),[cluster_color(j),'s'], 'MarkerFaceColor',cluster_color(j),'MarkerSize',5); hold on; 
end
hold off; axis image;
disp('This is the clustering result');
disp('The demo is finished.');

% the deformed kernel matrix evaluated over test data
