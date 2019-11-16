function build_data(numTrain,numTest,outputTrainingFile,outputTestingFile,dataset);

if strcmp(dataset,'15Scene') == 1
    tic
    fifteenSceneStartingNum = [0 217 458 769 979 1268 1628 1956 2216 2524 2898 3308 3600 3956 4171];

    %lets do sift for training data
    dataT = [];
    training_label = [];
    for i = 1:15
        tic
        if(i-1>9)
           directory =  num2str(i-1);
        else
           directory =  strcat('0',num2str(i-1));
        end
        for j = 1:numTrain
           img_path = strcat('../../../src/datasets/15CategoryDataSet/completeSet/15-Scene/',directory,'/',num2str(fifteenSceneStartingNum(i)+j),'.jpg');
            feature = SIFT_feature(img_path);
            dataT = [dataT feature];
            training_label=[training_label i*ones(1,size(feature,2))]; 
        end
        toc
    end
    save(outputTrainingFile,'dataT','training_label');

    %lets do sift for testing data

    dataT = [];
    testing_label = [];
    for i = 1:15
        if(i-1>9)
           directory =  num2str(i-1);
        else
           directory =  strcat('0',num2str(i-1));
        end
        for j = 1:numTest
           img_path = strcat('../../../src/datasets/15CategoryDataSet/completeSet/15-Scene/',directory,'/',num2str(fifteenSceneStartingNum(i)+j+numTrain+1),'.jpg');
            feature = SIFT_feature(img_path);
            dataT = [dataT feature];
            testing_label=[testing_label i*ones(1,size(feature,2))]; 
        end
    end
    save(outputTestingFile,'dataT','testing_label');
    disp('total time')
    toc
end
