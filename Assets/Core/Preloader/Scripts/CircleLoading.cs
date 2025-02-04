using UnityEngine;
using DG.Tweening;
using Prototype.SceneLoaderCore.Helpers;

namespace Octopus.Preloader
{
    public class CircleLoading : Loading
    {
        [SerializeField, Header("Progress")] private Transform loadingProgress;

        [SerializeField, Range(1.0f, 100.0f), Header("Angle Rotation")] private float rotationAngle = 100f;
        
        [SerializeField, Range(1.0f, 10.0f), Header("Speed Rotation")] private float rotationSpeed = 3f;

        private Tween _tween;

        [SerializeField] private bool isLoop;

        private void OnDisable()
        {
            FinishActiveTween();
        }

        protected override void Show()
        {
            base.Show();
            
            _tween?.Play();
        }
        
        protected override void Hide()
        {
            base.Hide();

            _tween?.Pause();
        }

        protected override void StartLoading()
        {
            _tween = loadingProgress.DORotate(Vector3.back * rotationAngle, rotationSpeed)
                .SetLoops(-1, LoopType.Incremental)
                .SetEase(Ease.Linear);

            if(!isLoop)
                DOVirtual.DelayedCall(2, OnLoadingComplete);
        }
        
        private void FinishActiveTween()
        {
            _tween.Kill();

            _tween = null;
        }
        
        private void OnLoadingComplete()
        {
            SceneLoader.Instance.SwitchToScene(SceneLoader.Instance.mainScene);
        }
    }
}