import 'package:flutter/material.dart';
import '../../shared/widgets/teal_app_bar.dart';
import '../../shared/widgets/teal_button.dart';
import '../../shared/widgets/teal_card.dart';
import '../../shared/widgets/teal_text_field.dart';
import '../../shared/widgets/teal_avatar.dart';
import '../../shared/widgets/teal_badge.dart';
import '../../shared/widgets/teal_chip.dart';
import '../../shared/widgets/teal_divider.dart';
import '../../shared/widgets/teal_dialog.dart' as teal_dialog;
import '../../shared/widgets/teal_bottom_sheet.dart';
import '../../shared/widgets/teal_loading.dart';

class TealComponentsDemo extends StatefulWidget {
  const TealComponentsDemo({super.key});

  @override
  State<TealComponentsDemo> createState() => _TealComponentsDemoState();
}

class _TealComponentsDemoState extends State<TealComponentsDemo> {
  bool _isLoading = false;
  String _selectedChip = '';
  List<String> _selectedChips = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TealAppBar(
        title: 'Teal Components Demo',
        type: TealAppBarType.gradient,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Buttons', _buildButtonsDemo()),
            _buildSection('Cards', _buildCardsDemo()),
            _buildSection('Text Fields', _buildTextFieldsDemo()),
            _buildSection('Avatars', _buildAvatarsDemo()),
            _buildSection('Badges', _buildBadgesDemo()),
            _buildSection('Chips', _buildChipsDemo()),
            _buildSection('Dividers', _buildDividersDemo()),
            _buildSection('Dialogs & Bottom Sheets', _buildDialogsDemo()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TealSectionDivider.withText(title: title),
        content,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildButtonsDemo() {
    return Column(
      children: [
        // 기본 버튼들
        Row(
          children: [
            Expanded(
              child: TealButton(
                text: 'Primary',
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TealButton(
                text: 'Secondary',
                type: TealButtonType.secondary,
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: TealButton(
                text: 'Outline',
                type: TealButtonType.outline,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TealButton(
                text: 'Danger',
                type: TealButtonType.danger,
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 로딩 버튼
        TealButton(
          text: 'Loading',
          isLoading: _isLoading,
          fullWidth: true,
          onPressed: () {
            setState(() => _isLoading = true);
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => _isLoading = false);
            });
          },
        ),
        const SizedBox(height: 8),
        
        // 아이콘 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TealButton.icon(
              icon: Icons.favorite,
              onPressed: () {},
              tooltip: 'Like',
            ),
            TealButton(
              text: 'With Icon',
              iconData: Icons.send,
              onPressed: () {},
              size: TealButtonSize.small,
            ),
            TealButton.text(
              text: 'Text Button',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsDemo() {
    return Column(
      children: [
        TealCard(
          child: Column(
            children: [
              const Text(
                'Standard Card',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('기본적인 카드 스타일입니다.'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        TealCard(
          type: TealCardType.elevated,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              TealSnackBar.info('Elevated card tapped!'),
            );
          },
          child: const Column(
            children: [
              Text(
                'Elevated Card',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('그림자가 있는 카드입니다. 탭해보세요!'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        ItemTealCard(
          imageUrl: '',
          title: '샘플 아이템',
          price: '10,000원/일',
          location: '서울시 강남구',
          rating: 4.5,
          isAvailable: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTextFieldsDemo() {
    return Column(
      children: [
        TealTextField(
          labelText: '이름',
          hintText: '이름을 입력하세요',
          prefixIcon: Icons.person,
          required: true,
          controller: _textController,
        ),
        const SizedBox(height: 16),
        
        TealTextField(
          labelText: '비밀번호',
          hintText: '비밀번호를 입력하세요',
          prefixIcon: Icons.lock,
          obscureText: true,
          required: true,
        ),
        const SizedBox(height: 16),
        
        TealDropdown<String>(
          labelText: '카테고리',
          hintText: '카테고리를 선택하세요',
          prefixIcon: Icons.category,
          items: const [
            DropdownMenuItem(value: '전자기기', child: Text('전자기기')),
            DropdownMenuItem(value: '의류', child: Text('의류')),
            DropdownMenuItem(value: '도서', child: Text('도서')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildAvatarsDemo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TealAvatar.user(
              name: '김철수',
              size: TealAvatarSize.small,
              isOnline: true,
            ),
            TealAvatar.user(
              name: '이영희',
              size: TealAvatarSize.medium,
            ),
            TealAvatar.user(
              name: '박민수',
              size: TealAvatarSize.large,
              isOnline: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TealAvatar.icon(
              icon: Icons.settings,
              size: TealAvatarSize.medium,
            ),
            TealEditableAvatar(
              name: '편집 가능',
              size: TealAvatarSize.large,
              onEdit: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        TealAvatarGroup(
          avatars: [
            TealAvatar.user(name: '사용자1'),
            TealAvatar.user(name: '사용자2'),
            TealAvatar.user(name: '사용자3'),
            TealAvatar.user(name: '사용자4'),
            TealAvatar.user(name: '사용자5'),
          ],
          maxVisible: 3,
          onMoreTap: () {},
        ),
      ],
    );
  }

  Widget _buildBadgesDemo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TealBadge.count(
              count: 5,
              child: const Icon(Icons.notifications, size: 32),
            ),
            TealBadge.text(
              text: 'NEW',
              type: TealBadgeType.success,
              child: const Icon(Icons.shopping_cart, size: 32),
            ),
            TealBadge.dot(
              type: TealBadgeType.error,
              child: const Icon(Icons.message, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TealNotificationBadge(
              count: 99,
              child: const Icon(Icons.mail, size: 32),
              onTap: () {},
            ),
            TealProgressBadge(
              progress: 0.7,
              child: const Icon(Icons.download, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 단독 배지들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TealBadge.text(text: 'Primary', type: TealBadgeType.primary),
            TealBadge.text(text: 'Success', type: TealBadgeType.success),
            TealBadge.text(text: 'Warning', type: TealBadgeType.warning),
            TealBadge.text(text: 'Error', type: TealBadgeType.error),
          ],
        ),
      ],
    );
  }

  Widget _buildChipsDemo() {
    return Column(
      children: [
        // 필터 칩
        Wrap(
          spacing: 8,
          children: [
            TealChip.filter(
              label: '전자기기',
              isSelected: _selectedChip == '전자기기',
              onSelected: (selected) {
                setState(() {
                  _selectedChip = selected ? '전자기기' : '';
                });
              },
            ),
            TealChip.filter(
              label: '의류',
              isSelected: _selectedChip == '의류',
              onSelected: (selected) {
                setState(() {
                  _selectedChip = selected ? '의류' : '';
                });
              },
            ),
            TealChip.filter(
              label: '도서',
              isSelected: _selectedChip == '도서',
              onSelected: (selected) {
                setState(() {
                  _selectedChip = selected ? '도서' : '';
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 액션 칩
        Wrap(
          spacing: 8,
          children: [
            TealChip.action(
              label: 'Primary',
              icon: Icons.star,
              onPressed: () {},
            ),
            TealChip.action(
              label: 'Success',
              type: TealChipType.success,
              icon: Icons.check,
              onPressed: () {},
            ),
            TealChip(
              label: 'Deletable',
              icon: Icons.tag,
              onDeleted: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 칩 그룹
        TealChipGroup(
          items: const ['태그1', '태그2', '태그3', '태그4'],
          selectedItems: _selectedChips,
          multiSelect: true,
          onSelectionChanged: (selected) {
            setState(() {
              _selectedChips = selected;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDividersDemo() {
    return Column(
      children: [
        const TealDivider(),
        const SizedBox(height: 8),
        
        const TealDivider(
          type: TealDividerType.dashed,
          style: TealDividerStyle.medium,
        ),
        const SizedBox(height: 8),
        
        const TealDivider(
          type: TealDividerType.dotted,
          style: TealDividerStyle.thick,
        ),
        const SizedBox(height: 8),
        
        TealDivider.gradient(),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(child: Container(height: 40, color: Colors.grey[200])),
            TealDivider.vertical(thickness: 2),
            Expanded(child: Container(height: 40, color: Colors.grey[200])),
            TealDivider.vertical(
              type: TealDividerType.dashed,
              thickness: 2,
            ),
            Expanded(child: Container(height: 40, color: Colors.grey[200])),
          ],
        ),
        const SizedBox(height: 16),
        
        TealSectionDivider.withText(title: '섹션 구분선'),
        
        const TealBrandDivider(animated: true),
      ],
    );
  }

  Widget _buildDialogsDemo() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TealButton(
                text: 'Alert Dialog',
                onPressed: () {
                  teal_dialog.TealDialog.showAlert(
                    context: context,
                    title: '알림',
                    message: '이것은 알림 다이얼로그입니다.',
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TealButton(
                text: 'Confirmation',
                type: TealButtonType.outline,
                onPressed: () async {
                  final result = await teal_dialog.TealDialog.showConfirmation(
                    context: context,
                    title: '확인',
                    message: '정말로 삭제하시겠습니까?',
                    isDestructive: true,
                  );
                  if (result == true && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      TealSnackBar.success('삭제되었습니다.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: TealButton(
                text: 'Input Dialog',
                onPressed: () async {
                  final result = await teal_dialog.TealInputDialog.show(
                    context: context,
                    title: '이름 입력',
                    hint: '이름을 입력하세요',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력해주세요';
                      }
                      return null;
                    },
                  );
                  if (result != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      TealSnackBar.info('입력된 이름: $result'),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TealButton(
                text: 'Bottom Sheet',
                type: TealButtonType.secondary,
                onPressed: () {
                  TealBottomSheetTemplates.showSelectionSheet<String>(
                    context: context,
                    title: '옵션 선택',
                    items: const [
                      TealSelectionItem(value: 'option1', label: '옵션 1'),
                      TealSelectionItem(value: 'option2', label: '옵션 2'),
                      TealSelectionItem(value: 'option3', label: '옵션 3'),
                    ],
                    showSearchBar: true,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}