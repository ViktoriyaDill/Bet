class StackTowerViewModel: BaseGameViewModel {
    override var gameType: GameType { .stackTower }
    
    @Published var blocks: [StackTowerBlock] = []
    @Published var currentBlock: StackTowerBlock?
    @Published var gameHeight: CGFloat = 0
    
    private let blockHeight: CGFloat = 30
    private var direction: CGFloat = 1
    
    override func startGame() {
        blocks = []
        gameHeight = 0
        createFirstBlock()
        super.startGame()
    }
    
    private func createFirstBlock() {
        let block = StackTowerBlock(
            width: 120,
            color: .systemBlue,
            position: CGPoint(x: 0, y: 0)
        )
        blocks.append(block)
        createMovingBlock()
    }
    
    private func createMovingBlock() {
        guard isGameActive else { return }
        
        let previousBlock = blocks.last!
        let newWidth = max(previousBlock.width - 20, 40)
        let newY = gameHeight + blockHeight
        
        currentBlock = StackTowerBlock(
            width: newWidth,
            color: UIColor.random(),
            position: CGPoint(x: -100, y: newY)
        )
        
        animateCurrentBlock()
    }
    
    private func animateCurrentBlock() {
        guard let block = currentBlock else { return }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
            guard let self = self, let currentBlock = self.currentBlock else {
                timer.invalidate()
                return
            }
            
            let newX = currentBlock.position.x + (self.direction * 3)
            
            if newX > 100 || newX < -100 {
                self.direction *= -1
            }
            
            self.currentBlock = StackTowerBlock(
                width: currentBlock.width,
                color: currentBlock.color,
                position: CGPoint(x: newX, y: currentBlock.position.y)
            )
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func dropBlock() {
        guard let current = currentBlock else { return }
        
        HapticManager.shared.impact(.light)
        
        blocks.append(current)
        currentBlock = nil
        gameHeight += blockHeight
        updateScore(blocks.count * 10)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.createMovingBlock()
        }
    }
}